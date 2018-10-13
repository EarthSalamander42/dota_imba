-- Editors:
--     MouJiaoZi, 06.12.2017

-------------------------------
--       MIRROR IMAGE        --
-------------------------------

imba_naga_siren_mirror_image = imba_naga_siren_mirror_image or class({})

LinkLuaModifier( "modifier_imba_naga_siren_mirror_image_invulnerable", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE )

function imba_naga_siren_mirror_image:IsHiddenWhenStolen() 		return false end
function imba_naga_siren_mirror_image:IsRefreshable() 			return true  end
function imba_naga_siren_mirror_image:IsStealable() 			return true  end
function imba_naga_siren_mirror_image:IsNetherWardStealable() 	return false end

function imba_naga_siren_mirror_image:OnSpellStart()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local caster_entid = caster:entindex()
	local ability = self
	local delay = ability:GetSpecialValueFor("invuln_duration")
	local image_count = ability:GetSpecialValueFor("images_count") + caster:FindTalentValue("special_bonus_unique_naga_siren")
	local image_out_dmg = ability:GetSpecialValueFor("outgoing_damage") + caster:FindTalentValue("special_bonus_unique_naga_siren_4")
	local image_in_dmg = ability:GetSpecialValueFor("incoming_damage")
	local image_duration = ability:GetSpecialValueFor("illusion_duration")
	local vRandomSpawnPos = {
		Vector( 72, 0, 0 ),
		Vector( 72, 72, 0 ),
		Vector( 72, 0, 0 ),
		Vector( 0, 72, 0 ),
		Vector( -72, 0, 0 ),
		Vector( -72, 72, 0 ),
		Vector( -72, -72, 0 ),
		Vector( 0, -72, 0 ),
	}
	local particle = "particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"
	local particle2 = "particles/units/heroes/hero_siren/naga_siren_riptide_foam.vpcf"
	local part = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN, caster)
	local buff = caster:AddNewModifier(caster, ability, "modifier_imba_naga_siren_mirror_image_invulnerable", {})
	EmitSoundOn("Hero_NagaSiren.MirrorImage", caster)
	caster:SetContextThink( DoUniqueString("naga_siren_mirror_image"), function ( )
		for i=1, image_count do
			local j = RandomInt(1, #vRandomSpawnPos)
			local pos = caster:GetAbsOrigin() + vRandomSpawnPos[j]
			local illusion = IllusionManager:CreateIllusion(caster, self, pos, caster, {damagein=image_in_dmg, damageout=image_out_dmg, unique=caster_entid.."_siren_image_"..i, duration=image_duration})
			table.remove(vRandomSpawnPos,j)
			local part2 = ParticleManager:CreateParticle(particle2, PATTACH_ABSORIGIN, illusion)
			ParticleManager:ReleaseParticleIndex(part2)
		end
		ParticleManager:DestroyParticle(part, true)
		ParticleManager:ReleaseParticleIndex(part)
		caster:Stop()
		buff:Destroy()
		return nil
	end, delay )
end

modifier_imba_naga_siren_mirror_image_invulnerable = modifier_imba_naga_siren_mirror_image_invulnerable or class({})

function modifier_imba_naga_siren_mirror_image_invulnerable:IsHidden()
	return true
end

function modifier_imba_naga_siren_mirror_image_invulnerable:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}

	return state
end

--=================================================================================================================
-- Naga Siren: Rip Tide
--=================================================================================================================

imba_naga_siren_rip_tide = imba_naga_siren_rip_tide or class({})

LinkLuaModifier( "modifier_imba_naga_siren_rip_tide_debuff", "components/abilities/heroes/hero_naga_siren.lua", LUA_MODIFIER_MOTION_NONE )

function imba_naga_siren_rip_tide:IsHiddenWhenStolen() 		return false end
function imba_naga_siren_rip_tide:IsRefreshable() 			return true  end
function imba_naga_siren_rip_tide:IsStealable() 			return true  end
function imba_naga_siren_rip_tide:IsNetherWardStealable() 	return true  end

function imba_naga_siren_rip_tide:GetCastRange() return self:GetSpecialValueFor("radius") end

function imba_naga_siren_rip_tide:OnAbilityPhaseStart()
	if not IsServer() then
		return
	end
	EmitSoundOn("Hero_NagaSiren.RipTide.Precast", self:GetCaster())
	return true
end

function imba_naga_siren_rip_tide:OnSpellStart()
	if not IsServer() then return end
	local ability = self
	local caster = self:GetCaster()
	local effect_radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetAbilityDamage()
	local damageType = ability:GetAbilityDamageType()
	local debuff_duration = ability:GetSpecialValueFor("duration")
	local pfxName = "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf"
	local illusion_buff_name = "modifier_illusion_manager"
	local caster_table = {}
	local victim_table = {}
	table.insert(caster_table, caster)
	local casters = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		9999999,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	for _, illusion_caster in pairs(casters) do
		if illusion_caster:GetUnitName() == caster:GetUnitName() and illusion_caster:FindModifierByNameAndCaster(illusion_buff_name, caster) then
			table.insert(caster_table, illusion_caster)
		end
	end

	for _, tide_caster in pairs(caster_table) do
		EmitSoundOn("Hero_NagaSiren.Riptide.Cast", tide_caster)
		tide_caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
		local part = ParticleManager:CreateParticle(pfxName, PATTACH_ABSORIGIN, tide_caster)
		ParticleManager:SetParticleControl(part, 1, Vector(effect_radius,effect_radius,effect_radius) )
		ParticleManager:SetParticleControl(part, 3, Vector(effect_radius,effect_radius,effect_radius) )
		ParticleManager:ReleaseParticleIndex(part)
		local victims = FindUnitsInRadius(tide_caster:GetTeamNumber(),
			tide_caster:GetAbsOrigin(),
			nil,
			effect_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)
		for _,victim in pairs(victims) do
			if not victim_table[victim:entindex()] then
				local damageTable = {
					victim = victim,
					attacker = tide_caster,
					damage = damage,
					damage_type = damageType,
					ability = ability,
				}
				ApplyDamage(damageTable)
				victim:AddNewModifier(caster, ability, "modifier_imba_naga_siren_rip_tide_debuff", {duration = debuff_duration})
				victim_table[victim:entindex()] = victim:entindex()
			end
		end
	end

end

modifier_imba_naga_siren_rip_tide_debuff = modifier_imba_naga_siren_rip_tide_debuff or class({})

function modifier_imba_naga_siren_rip_tide_debuff:IsDebuff()			return true end
function modifier_imba_naga_siren_rip_tide_debuff:IsHidden() 			return false  end
function modifier_imba_naga_siren_rip_tide_debuff:IsPurgable() 			return true end
function modifier_imba_naga_siren_rip_tide_debuff:IsPurgeException() 	return true end
function modifier_imba_naga_siren_rip_tide_debuff:IsStunDebuff() 		return false end
function modifier_imba_naga_siren_rip_tide_debuff:RemoveOnDeath() 		return true  end

function modifier_imba_naga_siren_rip_tide_debuff:GetEffectName() return "particles/units/heroes/hero_siren/naga_siren_riptide_debuff.vpcf" end

function modifier_imba_naga_siren_rip_tide_debuff:DeclareFunctions()
	local func = {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
	return func
end

function modifier_imba_naga_siren_rip_tide_debuff:GetModifierPhysicalArmorBonus() return (self:GetAbility():GetSpecialValueFor("armor_reduction") + self:GetCaster():FindTalentValue("special_bonus_unique_naga_siren_3")) end
