-- Editors:
--     EarthSalamander, 28.09.2019

--=================================================================================================================
-- Naga Siren: Mirror Image
--=================================================================================================================

imba_naga_siren_mirror_image = imba_naga_siren_mirror_image or class({})

LinkLuaModifier( "modifier_imba_naga_siren_mirror_image_invulnerable", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE )

function imba_naga_siren_mirror_image:IsHiddenWhenStolen() return false end
function imba_naga_siren_mirror_image:IsRefreshable() return true end
function imba_naga_siren_mirror_image:IsStealable() return true end
function imba_naga_siren_mirror_image:IsNetherWardStealable() return false end

function imba_naga_siren_mirror_image:OnSpellStart()
	if not IsServer() then return end

	local image_count = self:GetSpecialValueFor("images_count") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren")
	local image_out_dmg = self:GetSpecialValueFor("outgoing_damage") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren_4")

	local vRandomSpawnPos = {
		Vector( 108, 0, 0 ),
		Vector( 108, 108, 0 ),
		Vector( 108, 0, 0 ),
		Vector( 0, 108, 0 ),
		Vector( -108, 0, 0 ),
		Vector( -108, 108, 0 ),
		Vector( -108, -108, 0 ),
		Vector( 0, -108, 0 ),
	}

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf", PATTACH_ABSORIGIN, self:GetCaster())

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_mirror_image_invulnerable", {duration = self:GetSpecialValueFor("invuln_duration")})

	self:GetCaster():SetContextThink(DoUniqueString("naga_siren_mirror_image"), function()
		-- "API Additions - Global (Server): * CreateIllusions( hOwner, hHeroToCopy, hModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace ) Note: See script_help2 for supported modifier keys"
		local illusions = CreateIllusions(self:GetCaster(), self:GetCaster(), {
			outgoing_damage 			= image_out_dmg,
			incoming_damage				= self:GetSpecialValueFor("incoming_damage"),
			bounty_base					= self:GetCaster():GetIllusionBounty(),
			bounty_growth				= nil,
			outgoing_damage_structure	= nil,
			outgoing_damage_roshan		= nil,
			duration					= self:GetSpecialValueFor("illusion_duration")
		}, image_count, self:GetCaster():GetHullRadius(), true, true)

		for i = 1, #illusions do
			local illusion = illusions[i]
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
-- Naga Siren: Rip Tide
--=================================================================================================================

imba_naga_siren_rip_tide = imba_naga_siren_rip_tide or class({})

LinkLuaModifier( "modifier_imba_naga_siren_rip_tide_debuff", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE )

function imba_naga_siren_rip_tide:IsHiddenWhenStolen() return false end
function imba_naga_siren_rip_tide:IsRefreshable() return true end
function imba_naga_siren_rip_tide:IsStealable() return true end
function imba_naga_siren_rip_tide:IsNetherWardStealable() return true end
function imba_naga_siren_rip_tide:GetCastRange() return self:GetSpecialValueFor("radius") end

function imba_naga_siren_rip_tide:GetIntrinsicModifierName()
	return "modifier_imba_naga_siren_rip_tide_debuff"
end

modifier_imba_naga_siren_rip_tide_debuff = modifier_imba_naga_siren_rip_tide_debuff or class({})

function modifier_imba_naga_siren_rip_tide_debuff:IsDebuff() return true end
function modifier_imba_naga_siren_rip_tide_debuff:GetEffectName() return "particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf" end

function modifier_imba_naga_siren_rip_tide_debuff:DeclareFunctions() return {
	MODIFIER_EVENT_ON_ATTACK_LANDED,
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
} end

function modifier_imba_naga_siren_rip_tide_debuff:OnAttackLanded(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() and RandomInt(1, 100) <= self:GetAbility():GetSpecialValueFor("chance") then
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
			ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
			ParticleManager:SetParticleControl(pfx, 3, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
			ParticleManager:ReleaseParticleIndex(pfx)

			local victims = FindUnitsInRadius(tide_caster:GetTeamNumber(),
				tide_caster:GetAbsOrigin(),
				nil,
				self:GetSpecialValueFor("radius"),
				self:GetAbilityTargetTeam(),
				self:GetAbilityTargetType(),
				self:GetAbilityTargetFlags(),
				FIND_ANY_ORDER,
				false
			)

			for _, victim in pairs(victims) do
				if not victim_table[victim:entindex()] then
					local damageTable = {
						victim = victim,
						attacker = tide_caster,
						damage = self:GetAbilityDamage(),
						damage_type = self:GetAbilityDamageType(),
						ability = self,
					}

					ApplyDamage(damageTable)

					victim:AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_rip_tide_debuff", {duration = self:GetSpecialValueFor("duration")})
					victim_table[victim:entindex()] = victim:entindex()
				end
			end
		end
	end
end

function modifier_imba_naga_siren_rip_tide_debuff:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren_3")
end
