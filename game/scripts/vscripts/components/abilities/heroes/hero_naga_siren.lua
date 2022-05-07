-- Editors:
--     EarthSalamander, 28.09.2019

--=================================================================================================================
-- Naga Siren: Mirror Image
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_mirror_image_invulnerable", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_naga_siren_mirror_image_perfect_image", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

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
			incoming_damage				= self:GetSpecialValueFor("incoming_damage") - self:GetCaster():FindTalentValue("special_bonus_imba_naga_siren_mirror_image_damage_taken"),
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
			illusion:AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_mirror_image_perfect_image", {})
		end

		ParticleManager:DestroyParticle(pfx, false)
		ParticleManager:ReleaseParticleIndex(pfx)

		self:GetCaster():Stop()

		return nil
	end, self:GetSpecialValueFor("invuln_duration"))

	self:GetCaster():EmitSound("Hero_NagaSiren.MirrorImage")
end

modifier_imba_naga_siren_mirror_image_invulnerable = modifier_imba_naga_siren_mirror_image_invulnerable or class({})

function modifier_imba_naga_siren_mirror_image_invulnerable:IsHidden() return true end

function modifier_imba_naga_siren_mirror_image_invulnerable:CheckState() return {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_STUNNED] = true,
	-- [MODIFIER_STATE_OUT_OF_GAME] = true,
} end

modifier_imba_naga_siren_mirror_image_perfect_image = modifier_imba_naga_siren_mirror_image_perfect_image or class({})

function modifier_imba_naga_siren_mirror_image_perfect_image:IsPurgable() return false end
function modifier_imba_naga_siren_mirror_image_perfect_image:IsPurgeException() return false end

function modifier_imba_naga_siren_mirror_image_perfect_image:OnCreated()
	self.perfect_image_bonus_damage_incoming_pct					= self:GetAbility():GetSpecialValueFor("perfect_image_bonus_damage_incoming_pct")
	self.perfect_image_bonus_damage_outgoing_pct					= self:GetAbility():GetTalentSpecialValueFor("perfect_image_bonus_damage_outgoing_pct")
	self.perfect_image_max_stacks									= self:GetAbility():GetSpecialValueFor("perfect_image_max_stacks")
end

function modifier_imba_naga_siren_mirror_image_perfect_image:DeclareFunctions() return {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	MODIFIER_EVENT_ON_DEATH,
} end

function modifier_imba_naga_siren_mirror_image_perfect_image:GetModifierIncomingDamage_Percentage()
	return self:GetStackCount() * self.perfect_image_bonus_damage_incoming_pct
end

function modifier_imba_naga_siren_mirror_image_perfect_image:GetModifierDamageOutgoing_Percentage()
	return self:GetStackCount() * self.perfect_image_bonus_damage_outgoing_pct
end

function modifier_imba_naga_siren_mirror_image_perfect_image:OnDeath(params)
	if not IsServer() then return end

	if params.attacker == self:GetParent() then
		if params.unit:IsRealHero() then
			self:SetIllusionsStackCount(self.perfect_image_max_stacks)
		else
			self:SetIllusionsStackCount(math.min(self:GetStackCount() + 1, self.perfect_image_max_stacks))
		end
	end
end

function modifier_imba_naga_siren_mirror_image_perfect_image:SetIllusionsStackCount(iStackCount)
	if self:GetAbility().illusions == nil then return end

	for _, illusion in pairs(self:GetAbility().illusions) do
		if illusion and not illusion:IsNull() then
			local modifier = illusion:FindModifierByName(self:GetName())

			if modifier then
				modifier:SetStackCount(iStackCount)
			end
		end
	end
end

--=================================================================================================================
-- Naga Siren: Ensnare
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_ensnare", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

imba_naga_siren_ensnare = imba_naga_siren_ensnare or class({})

function imba_naga_siren_ensnare:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self, iLevel) - self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren_2")
end

function imba_naga_siren_ensnare:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	local mirror_image = self:GetCaster():FindAbilityByName("imba_naga_siren_mirror_image")

	if mirror_image and mirror_image.illusions then
		for _, illusion in pairs(mirror_image.illusions) do
			if IsValidEntity(illusion) and illusion:IsAlive() then
				illusion:FadeGesture(ACT_DOTA_CAST_ABILITY_2)
			end
		end
	end

	return true
end

function imba_naga_siren_ensnare:OnAbilityPhaseStart()
	if not IsServer() then return end

	local mirror_image = self:GetCaster():FindAbilityByName("imba_naga_siren_mirror_image")
	self.naga_sirens = {}

	if mirror_image and mirror_image.illusions then
		for _, illusion in pairs(mirror_image.illusions) do
			if IsValidEntity(illusion) and illusion:IsAlive() then
				table.insert(self.naga_sirens, illusion)
				illusion:StartGesture(ACT_DOTA_CAST_ABILITY_2)
			end
		end
	end

	return true
end

function imba_naga_siren_ensnare:OnSpellStart()
	if self:GetCursorTarget():TriggerSpellAbsorb(self) then return end
	if not IsServer() then return end

	local net_speed = self:GetSpecialValueFor("net_speed")
	local distance = (self:GetCursorTarget():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D()
	local projectile_duration = distance / net_speed

	self:LaunchProjectile(self:GetCaster(), self:GetCursorTarget(), projectile_duration)

	if #self.naga_sirens > 0 then
		self.naga_sirens[RandomInt(1, #self.naga_sirens)]:EmitSound("Hero_NagaSiren.Ensnare.Cast")
	else
		self:GetCaster():EmitSound("Hero_NagaSiren.Ensnare.Cast")
	end

	for _, naga in pairs(self.naga_sirens) do
		if IsValidEntity(naga) and naga:IsAlive() then
--			local target = self:GetCursorTarget()
			local enemies = FindUnitsInRadius(
				naga:GetTeamNumber(),
				naga:GetAbsOrigin(),
				nil,
				self:GetSpecialValueFor("fake_ensnare_distance"),
				self:GetAbilityTargetTeam(),
				self:GetAbilityTargetType(),
				self:GetAbilityTargetFlags(),
				FIND_CLOSEST,
				false
			)

			if #enemies > 0 then
				self:LaunchProjectile(naga, enemies[1], projectile_duration)
			end
		end
	end
end

function imba_naga_siren_ensnare:LaunchProjectile(source, target, projectile_duration)
	local net_speed = self:GetSpecialValueFor("net_speed")

	if source:IsIllusion() then
		net_speed = (target:GetAbsOrigin() - source:GetAbsOrigin()):Length2D() / projectile_duration 
	end

	local info = {
		Target = target,
		Source = source,
		Ability = self,
		bDodgeable = true,
		EffectName = "particles/units/heroes/hero_siren/siren_net_projectile.vpcf",
		iMoveSpeed = net_speed,
		ExtraData = {illusion = source:IsIllusion()}
	}

	ProjectileManager:CreateTrackingProjectile(info)
end

function imba_naga_siren_ensnare:OnProjectileHit_ExtraData(hTarget, vLocation, hExtraData)
--	if hExtraData.illusion == 0 and hTarget and not hTarget:TriggerSpellAbsorb(self) then
	if hTarget then
		if not hTarget:HasModifier("modifier_imba_naga_siren_ensnare") then
			hTarget:EmitSound("Hero_NagaSiren.Ensnare.Target")
		end

		hTarget:AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_ensnare", {duration = self:GetSpecialValueFor("duration") * (1 - hTarget:GetStatusResistance())})
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

	if params.attacker == self:GetParent() and RollPseudoRandom(self:GetAbility():GetSpecialValueFor("chance") + self:GetCaster():FindTalentValue("special_bonus_imba_naga_siren_rip_tide_proc_chance"), self) then
		local caster_table = {}
		local victim_table = {}

		table.insert(caster_table, self:GetCaster())

		for _, unit in pairs(self:GetCaster():GetAdditionalOwnedUnits()) do
--			print(unit:GetUnitName(), unit:entindex())

			if unit:GetUnitName() == self:GetCaster():GetUnitName() and unit:IsIllusion() then
				table.insert(caster_table, unit)
			end
		end

		for _, tide_caster in pairs(caster_table) do
			tide_caster:EmitSound("Hero_NagaSiren.Riptide.Cast")
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
					local damage = self:GetAbility():GetSpecialValueFor("damage")
					local mod = victim:FindModifierByName("modifier_imba_naga_siren_rip_tide_debuff")

					if mod then
						local mod = victim:FindModifierByName("modifier_imba_naga_siren_rip_tide_debuff")
						mod:SetDuration(self:GetAbility():GetSpecialValueFor("duration") * (1 - victim:GetStatusResistance()), true)
						mod:SetStackCount(mod:GetStackCount() + 1)
						damage = damage + (self:GetAbility():GetSpecialValueFor("wet_bonus_damage") * mod:GetStackCount())
					else
						-- self:GetCaster():GetPlayerOwner():GetAssignedHero() is to allow the armor reduction talent from the real unit to apply
						mod = victim:AddNewModifier(self:GetCaster():GetPlayerOwner():GetAssignedHero(), self:GetAbility(), "modifier_imba_naga_siren_rip_tide_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration") * (1 - victim:GetStatusResistance())}):SetStackCount(1)
						damage = damage + self:GetAbility():GetSpecialValueFor("wet_bonus_damage")
					end

					local damageTable = {
						victim = victim,
						attacker = tide_caster,
						damage = damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self,
					}

					ApplyDamage(damageTable)

					victim_table[victim:entindex()] = victim:entindex()
				end
			end
		end
	end
end

modifier_imba_naga_siren_rip_tide_debuff = modifier_imba_naga_siren_rip_tide_debuff or class({})

function modifier_imba_naga_siren_rip_tide_debuff:IsDebuff() return true end
function modifier_imba_naga_siren_rip_tide_debuff:GetEffectName() return "particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf" end

function modifier_imba_naga_siren_rip_tide_debuff:GetTexture()
	return "naga_siren_rip_tide"
end

function modifier_imba_naga_siren_rip_tide_debuff:OnCreated()
	self.armor_reduction	= self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():FindTalentValue("special_bonus_imba_naga_siren_rip_tide_armor")
	self.wet_bonus_armor	= self:GetAbility():GetSpecialValueFor("wet_bonus_armor")
end

function modifier_imba_naga_siren_rip_tide_debuff:OnRefresh()
	self:OnCreated()
end

function modifier_imba_naga_siren_rip_tide_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
} end

function modifier_imba_naga_siren_rip_tide_debuff:GetModifierPhysicalArmorBonus()
	return (self.wet_bonus_armor * self:GetStackCount()) + self.armor_reduction
end

--=================================================================================================================
-- Naga Siren: Song of the Siren
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_song_of_the_siren_aura", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_naga_siren_song_of_the_siren", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

imba_naga_siren_song_of_the_siren = imba_naga_siren_song_of_the_siren or class({})

function imba_naga_siren_song_of_the_siren:OnSpellStart()
	if not IsServer() then return end

	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

	if self:GetAutoCastState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_siren_temptation_aura", {duration = self:GetSpecialValueFor("duration")})
		ParticleManager:SetParticleControl(pfx, 61, Vector(1, 0, 0))
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_song_of_the_siren_aura", {duration = self:GetSpecialValueFor("duration")})
	end

	if self:GetCaster():HasScepter() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_naga_siren_song_of_the_siren_heal_aura", {duration = self:GetSpecialValueFor("duration")})
	end

	self:GetCaster():EmitSound("Hero_NagaSiren.SongOfTheSiren")

	ParticleManager:ReleaseParticleIndex(pfx)
end

modifier_imba_naga_siren_song_of_the_siren_aura = modifier_imba_naga_siren_song_of_the_siren_aura or class({})

function modifier_imba_naga_siren_song_of_the_siren_aura:IsPurgable() return false end
function modifier_imba_naga_siren_song_of_the_siren_aura:IsPurgeException() return false end

function modifier_imba_naga_siren_song_of_the_siren_aura:IsAura() return true end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraDuration() return self:GetAbility():GetSpecialValueFor("aura_linger") end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_imba_naga_siren_song_of_the_siren_aura:GetModifierAura() return "modifier_imba_naga_siren_song_of_the_siren" end

function modifier_imba_naga_siren_song_of_the_siren_aura:OnCreated()
	if not IsServer() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())

	self:GetCaster():SwapAbilities(self:GetAbility():GetAbilityName(), "imba_naga_siren_song_of_the_siren_cancel", false, true)
end

function modifier_imba_naga_siren_song_of_the_siren_aura:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	self:GetCaster():EmitSound("Hero_NagaSiren.SongOfTheSiren.Cancel")
	self:GetCaster():StopSound("Hero_NagaSiren.SongOfTheSiren")

	self:GetCaster():SwapAbilities(self:GetAbility():GetAbilityName(), "imba_naga_siren_song_of_the_siren_cancel", true, false)
end

modifier_imba_naga_siren_song_of_the_siren = modifier_imba_naga_siren_song_of_the_siren or class({})

function modifier_imba_naga_siren_song_of_the_siren:IsDebuff() return true end
function modifier_imba_naga_siren_song_of_the_siren:IsPurgable() return false end
function modifier_imba_naga_siren_song_of_the_siren:IsPurgeException() return false end

function modifier_imba_naga_siren_song_of_the_siren:OnCreated()
	if not IsServer() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
end

function modifier_imba_naga_siren_song_of_the_siren:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

function modifier_imba_naga_siren_song_of_the_siren:CheckState() return {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NIGHTMARED] = true,
	[MODIFIER_STATE_STUNNED] = true,
} end

function modifier_imba_naga_siren_song_of_the_siren:DeclareFunctions()
	return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION}
end

function modifier_imba_naga_siren_song_of_the_siren:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

--=================================================================================================================
-- Naga Siren: Song of the Siren (Cancel)
--=================================================================================================================

imba_naga_siren_song_of_the_siren_cancel = imba_naga_siren_song_of_the_siren_cancel or class({})

function imba_naga_siren_song_of_the_siren_cancel:IsInnateAbility()	return true end
function imba_naga_siren_song_of_the_siren_cancel:ProcsMagicStick() return false end
function imba_naga_siren_song_of_the_siren_cancel:OnSpellStart()
	if not IsServer() then return end

	self:GetCaster():RemoveModifierByName("modifier_imba_naga_siren_song_of_the_siren_aura")
	self:GetCaster():RemoveModifierByName("modifier_imba_naga_siren_song_of_the_siren_heal_aura")
	self:GetCaster():RemoveModifierByName("modifier_imba_naga_siren_siren_temptation_aura")
end

--=================================================================================================================
-- Naga Siren: Song of the Siren (Aghanim Scepter aura)
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_song_of_the_siren_heal_aura", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_naga_siren_song_of_the_siren_healing", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_naga_siren_song_of_the_siren_heal_aura = modifier_imba_naga_siren_song_of_the_siren_heal_aura or class({})

function modifier_imba_naga_siren_song_of_the_siren_heal_aura:IsHidden() return true end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:IsPurgable() return false end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:IsPurgeException() return false end

function modifier_imba_naga_siren_song_of_the_siren_heal_aura:IsAura() return true end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:GetAuraDuration() return self:GetAbility():GetSpecialValueFor("aura_linger") end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_imba_naga_siren_song_of_the_siren_heal_aura:GetModifierAura() return "modifier_imba_naga_siren_song_of_the_siren_healing" end

modifier_imba_naga_siren_song_of_the_siren_healing = modifier_imba_naga_siren_song_of_the_siren_healing or class({})

function modifier_imba_naga_siren_song_of_the_siren_healing:IsPurgable() return false end
function modifier_imba_naga_siren_song_of_the_siren_healing:IsPurgeException() return false end

function modifier_imba_naga_siren_song_of_the_siren_healing:DeclareFunctions() return {
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
} end

function modifier_imba_naga_siren_song_of_the_siren_healing:GetModifierHealthRegenPercentage()
	return self:GetAbility():GetSpecialValueFor("scepter_regen_rate")
end

--=================================================================================================================
-- Naga Siren: Siren's Temptation
--=================================================================================================================

LinkLuaModifier("modifier_imba_naga_siren_siren_temptation_aura", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_naga_siren_siren_temptation_debuff", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE)

modifier_imba_naga_siren_siren_temptation_aura = modifier_imba_naga_siren_siren_temptation_aura or class({})

function modifier_imba_naga_siren_siren_temptation_aura:IsHidden() return true end
function modifier_imba_naga_siren_siren_temptation_aura:IsPurgable() return false end
function modifier_imba_naga_siren_siren_temptation_aura:IsPurgeException() return false end

function modifier_imba_naga_siren_siren_temptation_aura:IsAura() return true end
function modifier_imba_naga_siren_siren_temptation_aura:GetAuraDuration() return self:GetAbility():GetSpecialValueFor("aura_linger") end
function modifier_imba_naga_siren_siren_temptation_aura:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_imba_naga_siren_siren_temptation_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_imba_naga_siren_siren_temptation_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_imba_naga_siren_siren_temptation_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_imba_naga_siren_siren_temptation_aura:GetModifierAura() return "modifier_imba_naga_siren_siren_temptation_debuff" end

function modifier_imba_naga_siren_siren_temptation_aura:OnCreated()
	if not IsServer() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.pfx, 61, Vector(1, 0, 0))

	self:GetCaster():SwapAbilities(self:GetAbility():GetAbilityName(), "imba_naga_siren_song_of_the_siren_cancel", false, true)
end

function modifier_imba_naga_siren_siren_temptation_aura:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end

	self:GetCaster():EmitSound("Hero_NagaSiren.SongOfTheSiren.Cancel")
	self:GetCaster():StopSound("Hero_NagaSiren.SongOfTheSiren")

	self:GetCaster():SwapAbilities(self:GetAbility():GetAbilityName(), "imba_naga_siren_song_of_the_siren_cancel", true, false)
end

modifier_imba_naga_siren_siren_temptation_debuff = modifier_imba_naga_siren_siren_temptation_debuff or class({})

function modifier_imba_naga_siren_siren_temptation_debuff:IsDebuff() return true end
function modifier_imba_naga_siren_siren_temptation_debuff:IsPurgable() return false end
function modifier_imba_naga_siren_siren_temptation_debuff:IsPurgeException() return false end

function modifier_imba_naga_siren_siren_temptation_debuff:DeclareFunctions() return {
	MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	-- MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
} end

function modifier_imba_naga_siren_siren_temptation_debuff:OnCreated()
	if not IsServer() then return end

	self.pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControl(self.pfx, 61, Vector(1, 0, 0))
end

function modifier_imba_naga_siren_siren_temptation_debuff:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("siren_temptation_incoming_damage_pct")
end

-- function modifier_imba_naga_siren_siren_temptation_debuff:GetModifierMagicalResistanceBonus()
	-- return self:GetAbility():GetSpecialValueFor("siren_temptation_magical_resistance_reduction_pct") * (-1)
-- end

function modifier_imba_naga_siren_siren_temptation_debuff:OnDestroy()
	if not IsServer() then return end

	if self.pfx then
		ParticleManager:DestroyParticle(self.pfx, false)
		ParticleManager:ReleaseParticleIndex(self.pfx)
	end
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_naga_siren_rip_tide_proc_chance", "components/abilities/heroes/hero_naga_siren", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_naga_siren_mirror_image_damage_taken", "components/abilities/heroes/hero_naga_siren", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_naga_siren_rip_tide_proc_chance						= modifier_special_bonus_imba_naga_siren_rip_tide_proc_chance or class({})
modifier_special_bonus_imba_naga_siren_mirror_image_damage_taken				= modifier_special_bonus_imba_naga_siren_mirror_image_damage_taken or class({})

function modifier_special_bonus_imba_naga_siren_rip_tide_proc_chance:IsHidden() 		return true end
function modifier_special_bonus_imba_naga_siren_rip_tide_proc_chance:IsPurgable() 	return false end
function modifier_special_bonus_imba_naga_siren_rip_tide_proc_chance:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_naga_siren_mirror_image_damage_taken:IsHidden() 		return true end
function modifier_special_bonus_imba_naga_siren_mirror_image_damage_taken:IsPurgable() 	return false end
function modifier_special_bonus_imba_naga_siren_mirror_image_damage_taken:RemoveOnDeath() 	return false end

LinkLuaModifier("modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image", "components/abilities/heroes/hero_naga_siren", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_naga_siren_rip_tide_armor", "components/abilities/heroes/hero_naga_siren", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image	= modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image or class({})
modifier_special_bonus_imba_naga_siren_rip_tide_armor				= modifier_special_bonus_imba_naga_siren_rip_tide_armor or class({})

function modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image:IsHidden() 		return true end
function modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image:IsPurgable() 	return false end
function modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image:RemoveOnDeath() 	return false end

function modifier_special_bonus_imba_naga_siren_rip_tide_armor:IsHidden() 		return true end
function modifier_special_bonus_imba_naga_siren_rip_tide_armor:IsPurgable() 	return false end
function modifier_special_bonus_imba_naga_siren_rip_tide_armor:RemoveOnDeath() 	return false end

function imba_naga_siren_rip_tide:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_naga_siren_rip_tide_armor") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_naga_siren_mirror_image_perfect_image"), "modifier_special_bonus_imba_naga_siren_mirror_image_perfect_image", {})
	end
end

function imba_naga_siren_rip_tide:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_naga_siren_rip_tide_armor") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_naga_siren_rip_tide_armor") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_naga_siren_rip_tide_armor"), "modifier_special_bonus_imba_naga_siren_rip_tide_armor", {})
	end
end
