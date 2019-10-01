-- Editors:
--     EarthSalamander, 28.09.2019

--=================================================================================================================
-- Naga Siren: Mirror Image
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_mirror_image_invulnerable", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

imba_naga_siren_mirror_image = imba_naga_siren_mirror_image or class({})

function imba_naga_siren_mirror_image:IsHiddenWhenStolen() return false end
function imba_naga_siren_mirror_image:IsRefreshable() return true end
function imba_naga_siren_mirror_image:IsStealable() return true end
function imba_naga_siren_mirror_image:IsNetherWardStealable() return false end

function imba_naga_siren_mirror_image:OnSpellStart()
	if not IsServer() then return end

	local image_count = self:GetSpecialValueFor("images_count") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren")
	local image_out_dmg = self:GetSpecialValueFor("outgoing_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren_4")

	local vRandomSpawnPos = {
		Vector(108, 0, 0),
		Vector(108, 108, 0),
		Vector(108, 0, 0),
		Vector(0, 108, 0),
		Vector(-108, 0, 0),
		Vector(-108, 108, 0),
		Vector(-108, -108, 0),
		Vector(0, -108, 0),
	}

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf", PATTACH_ABSORIGIN, self:GetCaster())

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_mirror_image_invulnerable", {duration = self:GetSpecialValueFor("invuln_duration")})

	if self.illusions then
		for _, illusion in pairs(self.illusions) do
			if IsValidEntity(illusion) and illusion:IsAlive() then
				illusion:ForceKill(false)
			end
		end
	end

	self:GetCaster():SetContextThink(DoUniqueString("naga_siren_mirror_image"), function()
		-- "API Additions - Global (Server): * CreateIllusions( hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace ) Note: See script_help2 for supported modifier keys"
		self.illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
			outgoing_damage 			= image_out_dmg,
			incoming_damage				= self:GetSpecialValueFor("incoming_damage"),
			bounty_base					= self:GetCaster():GetIllusionBounty(),
			bounty_growth				= nil,
			outgoing_damage_structure	= nil,
			outgoing_damage_roshan		= nil,
--			duration					= self:GetSpecialValueFor("illusion_duration")
			duration					= nil -- IMBAfication: Everlasting Reflection
		}, image_count, self:GetCaster():GetHullRadius(), true, true)

		for i = 1, #self.illusions do
			local illusion = self.illusions[i]
			local pos = self:GetCaster():GetAbsOrigin() + vRandomSpawnPos[i]
			FindClearSpaceForUnit(illusion, pos, true)
			local part2 = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide_foam.vpcf", PATTACH_ABSORIGIN, illusion)
			ParticleManager:ReleaseParticleIndex(part2)
		end

		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)

		self:GetCaster():Stop()

		return nil
	end, self:GetSpecialValueFor("invuln_duration"))

	EmitSoundOn("Hero_NagaSiren.MirrorImage", self:GetCaster())
end

modifier_imba_naga_siren_mirror_image_invulnerable = modifier_imba_naga_siren_mirror_image_invulnerable or class({})

function modifier_imba_naga_siren_mirror_image_invulnerable:IsHidden() return true end

function modifier_imba_naga_siren_mirror_image_invulnerable:CheckState() return {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_STUNNED] = true,
	[MODIFIER_STATE_OUT_OF_GAME] = true,
} end

--=================================================================================================================
-- Naga Siren: Ensnare
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_ensnare", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

imba_naga_siren_ensnare = imba_naga_siren_ensnare or class({})

function imba_naga_siren_ensnare:OnAbilityPhaseStart()
	if not IsServer() then return end

	local mirror_image = self:GetCaster():FindAbilityByName("imba_naga_siren_mirror_image")
	self.naga_sirens = {}

	table.insert(self.naga_sirens, self:GetCaster())

	if mirror_image and mirror_image.illusions then
		for _, illusion in pairs(mirror_image.illusions) do
			if IsValidEntity(illusion) and illusion:IsAlive() and (self:GetCaster():GetAbsOrigin() - illusion:GetAbsOrigin()):Length2D() <= self:GetSpecialValueFor("fake_ensnare_distance") then
				table.insert(self.naga_sirens, illusion)
				illusion:StartGesture(ACT_DOTA_CAST_ABILITY_2)
			end
		end
	end

	return true
end

function imba_naga_siren_ensnare:OnSpellStart()
	if not IsServer() then return end

	local net_speed = self:GetSpecialValueFor("net_speed")
	local distance = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
	local projectile_duration = distance / net_speed

	self.naga_sirens[RandomInt(1, #self.naga_sirens)]:EmitSound("Hero_NagaSiren.Ensnare.Cast")

	for _, naga in pairs(self.naga_sirens) do
		if IsValidEntity(naga) and naga:IsAlive() then
			local target = self:GetCursorTarget()
			local this_naga_speed = (target:GetAbsOrigin() - naga:GetAbsOrigin()):Length2D() / projectile_duration 

			local info = {
				Target = target,
				Source = naga,
				Ability = self,
				bDodgeable = true,
				EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
				iMoveSpeed = this_naga_speed,
				ExtraData = {illusion = naga:IsIllusion()}
			}

			ProjectileManager:CreateTrackingProjectile(info)
		end
	end
end

function imba_naga_siren_ensnare:OnProjectileHit_ExtraData(hTarget, vLocation, hExtraData)
	if hExtraData.illusion == 0 and hTarget and not hTarget:TriggerSpellAbsorb(self) then
		hTarget:EmitSound("Hero_NagaSiren.Ensnare.Target")
		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_ensnare", {duration = self:GetSpecialValueFor("duration")})
	end
end

modifier_imba_naga_siren_ensnare = modifier_imba_naga_siren_ensnare or class({})

function modifier_imba_naga_siren_ensnare:IsDebuff() return true end
function modifier_imba_naga_siren_ensnare:GetEffectName() return "particles/units/heroes/hero_siren/siren_net.vpcf" end
function modifier_imba_naga_siren_ensnare:GetEffectAttachType() return PATTACH_ABSORIGIN end

function modifier_imba_naga_siren_ensnare:CheckState() return {
	[MODIFIER_STATE_ROOTED] = true,
} end

function modifier_imba_naga_siren_ensnare:DeclareFunctions() return {
	MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
} end

function modifier_imba_naga_siren_ensnare:GetModifierProvidesFOWVision()
	return 1
end

--=================================================================================================================
-- Naga Siren: Rip Tide
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_rip_tide", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_naga_siren_rip_tide_debuff", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

imba_naga_siren_rip_tide = imba_naga_siren_rip_tide or class({})

function imba_naga_siren_rip_tide:IsHiddenWhenStolen() return false end
function imba_naga_siren_rip_tide:IsRefreshable() return true end
function imba_naga_siren_rip_tide:IsStealable() return true end
function imba_naga_siren_rip_tide:IsNetherWardStealable() return true end
function imba_naga_siren_rip_tide:GetCastRange() return self:GetSpecialValueFor("radius") end

function imba_naga_siren_rip_tide:GetIntrinsicModifierName()
	return "modifier_imba_naga_siren_rip_tide"
end

modifier_imba_naga_siren_rip_tide = modifier_imba_naga_siren_rip_tide or class({})

function modifier_imba_naga_siren_rip_tide:IsHidden() return true end

function modifier_imba_naga_siren_rip_tide:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
} end

function modifier_imba_naga_siren_rip_tide:OnAttackLanded(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("chance"), self) then
		local caster_table = {}
		local victim_table = {}

		table.insert(caster_table, self:GetCaster())

		for _, unit in pairs(self:GetCaster():GetAdditionalOwnedUnits()) do
			print(unit:GetUnitName(), unit:entindex())

			if unit:GetUnitName() == self:GetCaster():GetUnitName() and unit:IsIllusion() then
				table.insert(caster_table, unit)
			end
		end

		for _, tide_caster in pairs(caster_table) do
			EmitSoundOn("Hero_NagaSiren.Riptide.Cast", tide_caster)
			tide_caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf", PATTACH_ABSORIGIN, tide_caster)
			ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius")))
			ParticleManager:SetParticleControl(pfx, 3, Vector(self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius"), self:GetAbility():GetSpecialValueFor("radius")))
			ParticleManager:ReleaseParticleIndex(pfx)

			local victims = FindUnitsInRadius(
				tide_caster:GetTeamNumber(),
				tide_caster:GetAbsOrigin(),
				nil,
				self:GetAbility():GetSpecialValueFor("radius"),
				self:GetAbility():GetAbilityTargetTeam(),
				self:GetAbility():GetAbilityTargetType(),
				self:GetAbility():GetAbilityTargetFlags(),
				FIND_ANY_ORDER,
				false
			)

			for _, victim in pairs(victims) do
				if not victim_table[victim:entindex()] then
					local damageTable = {
						victim = victim,
						attacker = tide_caster,
						damage = self:GetAbility():GetSpecialValueFor("damage"),
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self,
					}

					ApplyDamage(damageTable)

					victim:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_naga_siren_rip_tide_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")})
					victim_table[victim:entindex()] = victim:entindex()
				end
			end
		end
	end
end

modifier_imba_naga_siren_rip_tide_debuff = modifier_imba_naga_siren_rip_tide_debuff or class({})

function modifier_imba_naga_siren_rip_tide_debuff:IsDebuff() return true end
function modifier_imba_naga_siren_rip_tide_debuff:GetEffectName() return "particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf" end

function modifier_imba_naga_siren_rip_tide_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
} end

function modifier_imba_naga_siren_rip_tide_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren_3")
end

--=================================================================================================================
-- Naga Siren: Song of the Siren
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_song_of_the_siren_aura", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_naga_siren_song_of_the_siren_debuff", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

imba_naga_siren_song_of_the_siren = imba_naga_siren_song_of_the_siren or class({})

function imba_naga_siren_song_of_the_siren:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_song_of_the_siren_aura", {duration = self:GetSpecialValueFor("duration")})
end

modifier_imba_naga_siren_song_of_the_siren_aura = modifier_imba_naga_siren_song_of_the_siren_aura or class({})

function modifier_imba_naga_siren_song_of_the_siren_aura:IsHidden() return true end
function modifier_imba_naga_siren_song_of_the_siren_aura:IsPurgable() return false end
function modifier_imba_naga_siren_song_of_the_siren_aura:IsPurgeException() return false end

function modifier_imba_naga_siren_song_of_the_siren_aura:IsAura() return true end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraDuration() return self:GetAbility():GetSpecialValueFor("aura_linger") end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetModifierAura() return "modifier_imba_naga_siren_song_of_the_siren_debuff" end

function modifier_imba_naga_siren_song_of_the_siren_aura:OnCreated()
	if not IsServer() then return end

	self:GetCaster():SwapAbilities(self:GetAbility():GetAbilityName(), "imba_naga_siren_song_of_the_siren_cancel", false, true)
end

function modifier_imba_naga_siren_song_of_the_siren_aura:OnDestroy()
	if not IsServer() then return end

	self:GetCaster():SwapAbilities(self:GetAbility():GetAbilityName(), "imba_naga_siren_song_of_the_siren_cancel", true, false)
end

modifier_imba_naga_siren_song_of_the_siren_debuff = modifier_imba_naga_siren_song_of_the_siren_debuff or class({})

function modifier_imba_naga_siren_song_of_the_siren_debuff:IsDebuff() return true end
function modifier_imba_naga_siren_song_of_the_siren_debuff:IsPurgable() return false end
function modifier_imba_naga_siren_song_of_the_siren_debuff:IsPurgeException() return false end

function modifier_imba_naga_siren_song_of_the_siren_debuff:CheckState() return {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NIGHTMARED] = true,
	[MODIFIER_STATE_STUNNED] = true,
} end

--=================================================================================================================
-- Naga Siren: Song of the Siren (Cancel)
--=================================================================================================================

imba_naga_siren_song_of_the_siren_cancel = imba_naga_siren_song_of_the_siren_cancel or class({})

function imba_naga_siren_song_of_the_siren_cancel:IsInnateAbility() return true end

function imba_naga_siren_song_of_the_siren_cancel:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():RemoveModifierByName("modifier_imba_naga_siren_song_of_the_siren_aura")
end
