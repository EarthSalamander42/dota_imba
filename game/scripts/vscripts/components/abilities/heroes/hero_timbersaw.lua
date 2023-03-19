-- Creator:
--	   AltiV, September 19th, 2019

LinkLuaModifier("modifier_imba_timbersaw_whirling_death_thinker", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_timbersaw_whirling_death_debuff", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_timbersaw_whirling_death_oil", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_timbersaw_timber_chain", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_timbersaw_timber_chain_side_hooks", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_timbersaw_timber_chain_claw", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_timbersaw_reactive_armor", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_timbersaw_reactive_armor_stack", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_timbersaw_reactive_armor_debuff", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_timbersaw_chakram_thinker", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_imba_timbersaw_chakram_thinker_aura", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_timbersaw_chakram_debuff", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_timbersaw_chakram_disarm", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_imba_timbersaw_chakram_3", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

imba_timbersaw_whirling_death                   = class({})
modifier_imba_timbersaw_whirling_death_thinker  = class({})
modifier_imba_timbersaw_whirling_death_debuff   = class({})
modifier_imba_timbersaw_whirling_death_oil      = class({})

imba_timbersaw_timber_chain                     = class({})
modifier_imba_timbersaw_timber_chain            = class({})
modifier_imba_timbersaw_timber_chain_side_hooks = class({})
modifier_imba_timbersaw_timber_chain_claw       = class({})

imba_timbersaw_reactive_armor                   = class({})
modifier_imba_timbersaw_reactive_armor          = class({})
modifier_imba_timbersaw_reactive_armor_stack    = class({})
modifier_imba_timbersaw_reactive_armor_debuff   = class({})

imba_timbersaw_chakram                          = class({})
imba_timbersaw_chakram_2                        = class({})

modifier_imba_timbersaw_chakram_thinker         = class({})
modifier_imba_timbersaw_chakram_thinker_aura    = class({})
modifier_imba_timbersaw_chakram_debuff          = class({})
modifier_imba_timbersaw_chakram_disarm          = class({})

imba_timbersaw_return_chakram                   = class({})
imba_timbersaw_return_chakram_2                 = class({})

imba_timbersaw_chakram_3                        = class({})
modifier_imba_timbersaw_chakram_3               = class({})

----------------------------------
-- IMBA_TIMBERSAW_WHIRLING_DEATH --
----------------------------------

function imba_timbersaw_whirling_death:OnSpellStart()
	if self:GetCaster():GetName() == "npc_dota_hero_shredder" and RollPercentage(15) then
		if not self.responses then
			self.responses =
			{
				"shredder_timb_whirlingdeath_03",
				"shredder_timb_whirlingdeath_04",
				"shredder_timb_whirlingdeath_06"
			}
		end

		self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
	end

	if not self:GetAutoCastState() then
		self:WhirlingDeath()
	else
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_whirling_death_thinker", { duration = (self:GetSpecialValueFor("revving_down_instances") - 1) * self:GetSpecialValueFor("revving_down_interval") })
	end
end

-- Helper function (this will be called multiple times for the Revving Down IMBAfication)
function imba_timbersaw_whirling_death:WhirlingDeath(revving_down_efficacy)
	local efficacy = 1

	if revving_down_efficacy then
		efficacy = revving_down_efficacy / 100
	end

	self:GetCaster():EmitSound("Hero_Shredder.WhirlingDeath.Cast")

	local whirling_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_whirling_death.vpcf", PATTACH_CENTER_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(whirling_particle, 1, self:GetCaster(), PATTACH_CENTER_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(whirling_particle)

	local trees = GridNav:GetAllTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self:GetSpecialValueFor("whirling_radius"), false)

	if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
		self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
	end

	if self.dendrophobia_modifier then
		self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #trees)
	end

	GridNav:DestroyTreesAroundPoint(self:GetCaster():GetAbsOrigin(), self:GetSpecialValueFor("whirling_radius"), false)

	-- Check for at least one enemy hero to play the damage sound
	local hero_check = false

	-- "Whirling Death first applies the debuff, then the damage."
	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor("whirling_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if enemy:IsHero() and enemy.GetPrimaryStatValue then
			enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_whirling_death_debuff", {
				duration              = self:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance()),
				blood_oil_convert_pct = self:GetSpecialValueFor("blood_oil_convert_pct"),
				blood_oil_duration    = self:GetSpecialValueFor("blood_oil_duration"),
				efficacy              = efficacy
			})

			if not hero_check then
				hero_check = true
			end
		end

		ApplyDamage({
			victim       = enemy,
			damage       = (self:GetSpecialValueFor("whirling_damage") + #trees * self:GetSpecialValueFor("tree_damage_scale")) * efficacy,
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})
	end

	if hero_check then
		self:GetCaster():EmitSound("Hero_Shredder.WhirlingDeath.Damage")
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_WHIRLING_DEATH_THINKER --
---------------------------------------------------

function modifier_imba_timbersaw_whirling_death_thinker:IsHidden() return true end

function modifier_imba_timbersaw_whirling_death_thinker:IsPurgable() return false end

function modifier_imba_timbersaw_whirling_death_thinker:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_timbersaw_whirling_death_thinker:OnCreated()
	self.revving_down_efficacy = self:GetAbility():GetSpecialValueFor("revving_down_efficacy")

	if not IsServer() then return end

	self:OnIntervalThink()
	self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("revving_down_interval"))
end

function modifier_imba_timbersaw_whirling_death_thinker:OnIntervalThink()
	self:GetAbility():WhirlingDeath(self.revving_down_efficacy)
end

--------------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_WHIRLING_DEATH_DEBUFF --
--------------------------------------------------

function modifier_imba_timbersaw_whirling_death_debuff:GetEffectName() return "particles/units/heroes/hero_shredder/shredder_whirling_death_debuff.vpcf" end

function modifier_imba_timbersaw_whirling_death_debuff:GetStatusEffectName() return "particles/status_fx/status_effect_shredder_whirl.vpcf" end

function modifier_imba_timbersaw_whirling_death_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_timbersaw_whirling_death_debuff:OnCreated(params)
	if not IsServer() or not self:GetParent().GetPrimaryStatValue then return end

	self.efficacy = params.efficacy

	if not params.stat_loss_pct then
		self.primary_stat_loss = self:GetParent():GetPrimaryStatValue() * self:GetAbility():GetTalentSpecialValueFor("stat_loss_pct") / 100 * (-1) * self.efficacy
	else
		self.primary_stat_loss = self:GetParent():GetPrimaryStatValue() * params.stat_loss_pct / 100 * (-1)
	end

	-- IMBAfication: Blood to Oil
	self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_timbersaw_whirling_death_oil", {
		duration = params.blood_oil_duration,
		attribute = self:GetParent():GetPrimaryAttribute(),
		stat_gain = self.primary_stat_loss * params.blood_oil_convert_pct / 100 * (-1)
	})

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_timbersaw_whirling_death_debuff:OnIntervalThink()
	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end

	self:StartIntervalThink(-1)
end

function modifier_imba_timbersaw_whirling_death_debuff:OnDestroy()
	if not IsServer() then return end

	if self:GetParent().CalculateStatBonus then
		self:GetParent():CalculateStatBonus(true)
	end
end

function modifier_imba_timbersaw_whirling_death_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
end

if IsServer() then
	function modifier_imba_timbersaw_whirling_death_debuff:GetModifierBonusStats_Strength()
		if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_STRENGTH then return self.primary_stat_loss end
	end

	function modifier_imba_timbersaw_whirling_death_debuff:GetModifierBonusStats_Agility()
		if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_AGILITY then return self.primary_stat_loss end
	end

	function modifier_imba_timbersaw_whirling_death_debuff:GetModifierBonusStats_Intellect()
		if self:GetParent():GetPrimaryAttribute() == DOTA_ATTRIBUTE_INTELLECT then return self.primary_stat_loss end
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_WHIRLING_DEATH_OIL --
-----------------------------------------------

function modifier_imba_timbersaw_whirling_death_oil:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_imba_timbersaw_whirling_death_oil:OnCreated(params)
	if not IsServer() then return end

	self.attribute = params.attribute
	self.stat_gain = params.stat_gain

	self:StartIntervalThink(FrameTime())
end

function modifier_imba_timbersaw_whirling_death_oil:OnIntervalThink()
	self:GetParent():CalculateStatBonus(true)
	self:StartIntervalThink(-1)
end

function modifier_imba_timbersaw_whirling_death_oil:OnDestroy()
	if not IsServer() then return end

	self:GetParent():CalculateStatBonus(true)
end

function modifier_imba_timbersaw_whirling_death_oil:DeclareFunctions()
	return { MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS }
end

if IsServer() then
	function modifier_imba_timbersaw_whirling_death_oil:GetModifierBonusStats_Strength()
		if self.attribute == DOTA_ATTRIBUTE_STRENGTH then return self.stat_gain end
	end

	function modifier_imba_timbersaw_whirling_death_oil:GetModifierBonusStats_Agility()
		if self.attribute == DOTA_ATTRIBUTE_AGILITY then return self.stat_gain end
	end

	function modifier_imba_timbersaw_whirling_death_oil:GetModifierBonusStats_Intellect()
		if self.attribute == DOTA_ATTRIBUTE_INTELLECT then return self.stat_gain end
	end
end

--------------------------------
-- IMBA_TIMBERSAW_TIMBER_CHAIN --
--------------------------------

function imba_timbersaw_timber_chain:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + self:GetCaster():FindTalentValue("special_bonus_imba_timbersaw_timber_chain_range")
end

function imba_timbersaw_timber_chain:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	self:GetCaster():EmitSound("Hero_Shredder.TimberChain.Cast")

	local timber_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
	ParticleManager:SetParticleControlEnt(timber_particle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(timber_particle, 1, self:GetCaster():GetAbsOrigin() + ((self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * (self:GetTalentSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus())))
	ParticleManager:SetParticleControl(timber_particle, 2, Vector(self:GetSpecialValueFor("speed"), 0, 0))
	ParticleManager:SetParticleControl(timber_particle, 3, Vector(((self:GetTalentSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus()) / self:GetSpecialValueFor("speed")) * 2, 0, 0))

	if not self.projectiles then
		self.projectiles = {}
	end

	local ExtraData = {
		timber_particle = timber_particle,
		cast_pos_x      = self:GetCaster():GetAbsOrigin().x,
		cast_pos_y      = self:GetCaster():GetAbsOrigin().y,
		cast_pos_z      = self:GetCaster():GetAbsOrigin().z
	}

	local timber_projectile = ProjectileManager:CreateLinearProjectile({
		Source            = self:GetCaster(),
		Ability           = self,
		vSpawnOrigin      = self:GetCaster():GetAbsOrigin(),
		bDeleteOnHit      = false,
		-- EffectName = "particles/dev/library/base_linear_projectile_model.vpcf",
		fDistance         = self:GetTalentSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus(),
		vVelocity         = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0),
		fStartRadius      = self:GetSpecialValueFor("chain_radius"),
		fEndRadius        = self:GetSpecialValueFor("chain_radius"),
		-- Check that this works... (It doesn't)
		iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_BOTH,
		iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType   = DOTA_UNIT_TARGET_TREE,
		bHasFrontalCone   = true,
		bReplaceExisting  = false,
		fExpireTime       = GameRules:GetGameTime() + 10.0,
		-- "The chain's tip briefly provides 100 radius ground vision around itself while traveling, and 400 radius ground vision once reaching max distance or connecting with a tree."
		-- ...Yeah but how long does it give the 400 radius ground vision for though
		bProvidesVision   = true,
		iVisionRadius     = 100,
		iVisionTeamNumber = self:GetCaster():GetTeamNumber(),
		ExtraData         = ExtraData
	})

	self.projectiles[timber_projectile] = ExtraData

	-- This temporarily deletes the claw model from Timbersaw
	if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
		if self:GetCaster():GetTogglableWearable(DOTA_LOADOUT_TYPE_WEAPON) then
			self:GetCaster():GetTogglableWearable(DOTA_LOADOUT_TYPE_WEAPON):AddEffects(EF_NODRAW)
		end

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_timber_chain_claw", { duration = ((self:GetSpecialValueFor("range") + self:GetCaster():GetCastRangeBonus()) / self:GetSpecialValueFor("speed")) * 2 })
	end
end

function imba_timbersaw_timber_chain:OnProjectileThinkHandle(projectileHandle)
	if #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("chain_radius"), false) >= 1 and self.projectiles and self.projectiles[projectileHandle] and self.projectiles[projectileHandle].cast_pos_x then
		local valid_trees = GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)
		local tree = nil

		local original_caster_location = Vector(self.projectiles[projectileHandle].cast_pos_x, self.projectiles[projectileHandle].cast_pos_y, self.projectiles[projectileHandle].cast_pos_z)

		for _, other_tree in pairs(valid_trees) do
			-- This is to prevent Timbersaw from latching to trees behind him upon initial cast
			if (tree == nil or (other_tree ~= tree and (other_tree:GetAbsOrigin() - ProjectileManager:GetLinearProjectileLocation(projectileHandle)):Length2D() < (tree:GetAbsOrigin() - ProjectileManager:GetLinearProjectileLocation(projectileHandle)):Length2D())) and math.abs(AngleDiff(VectorToAngles(other_tree:GetAbsOrigin() - original_caster_location).y, VectorToAngles(ProjectileManager:GetLinearProjectileLocation(projectileHandle) - original_caster_location).y)) <= 90 then
				tree = other_tree
			end
		end

		if tree then
			EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Hero_Shredder.TimberChain.Impact", self:GetCaster())
			self:GetCaster():EmitSound("Hero_Shredder.TimberChain.Retract")

			ParticleManager:SetParticleControl(self.projectiles[projectileHandle].timber_particle, 1, tree:GetAbsOrigin())

			local direction = (tree:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()

			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_timber_chain", {
				-- The (self:GetCaster():GetHullRadius() * 8) is a bit arbitrary, but I want Timbersaw to stop at a location between the original position and the tree, and not fly past the tree
				duration                     = math.max(((tree:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() - (self:GetCaster():GetHullRadius() * 8)), 0) / self:GetSpecialValueFor("speed"),
				autocast_state               = self:GetAutoCastState(),
				direction_x                  = direction.x,
				direction_y                  = direction.y,
				direction_z                  = direction.z,
				tree_entindex                = tree:entindex(),
				damage_type                  = self:GetAbilityDamageType(),
				radius                       = self:GetSpecialValueFor("radius"),
				speed                        = self:GetSpecialValueFor("speed"),
				damage                       = self:GetSpecialValueFor("damage"),
				whirling_chain_stat_loss_pct = self:GetSpecialValueFor("whirling_chain_stat_loss_pct"),
				side_hooks_damage_reduction  = self:GetSpecialValueFor("side_hooks_damage_reduction"),
				side_hooks_drag_pct          = self:GetSpecialValueFor("side_hooks_drag_pct"),
				timber_particle              = self.projectiles[projectileHandle].timber_particle
			})

			self.projectiles[projectileHandle] = nil
			ProjectileManager:DestroyLinearProjectile(projectileHandle)

			if self:GetCaster():HasModifier("modifier_imba_timbersaw_timber_chain_claw") then
				self:GetCaster():FindModifierByName("modifier_imba_timbersaw_timber_chain_claw"):Destroy()
			end
		end
	else
		-- Yes, there's going to be a lot of code duplication here, but this is starting to make my eyes glaze over
		for _, ent in pairs(Entities:FindAllByClassname("npc_dota_thinker")) do
			if ent.bTimberChainTarget and (ProjectileManager:GetLinearProjectileLocation(projectileHandle) - ent:GetAbsOrigin()):Length2D() <= self:GetSpecialValueFor("chain_radius") then
				EmitSoundOnLocationWithCaster(ent:GetAbsOrigin(), "Hero_Shredder.TimberChain.Impact", self:GetCaster())
				self:GetCaster():EmitSound("Hero_Shredder.TimberChain.Retract")

				ParticleManager:SetParticleControl(self.projectiles[projectileHandle].timber_particle, 1, ent:GetAbsOrigin())

				local direction = (ent:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Normalized()

				self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_timber_chain", {
					duration                     = (ent:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() / self:GetSpecialValueFor("speed"),
					autocast_state               = self:GetAutoCastState(),
					direction_x                  = direction.x,
					direction_y                  = direction.y,
					direction_z                  = direction.z,
					tree_entindex                = ent:entindex(),
					damage_type                  = self:GetAbilityDamageType(),
					radius                       = self:GetSpecialValueFor("radius"),
					speed                        = self:GetSpecialValueFor("speed"),
					damage                       = self:GetSpecialValueFor("damage"),
					whirling_chain_stat_loss_pct = self:GetSpecialValueFor("whirling_chain_stat_loss_pct"),
					side_hooks_damage_reduction  = self:GetSpecialValueFor("side_hooks_damage_reduction"),
					side_hooks_drag_pct          = self:GetSpecialValueFor("side_hooks_drag_pct"),
					timber_particle              = self.projectiles[projectileHandle].timber_particle
				})

				self.projectiles[projectileHandle] = nil
				ProjectileManager:DestroyLinearProjectile(projectileHandle)

				if self:GetCaster():HasModifier("modifier_imba_timbersaw_timber_chain_claw") then
					self:GetCaster():FindModifierByName("modifier_imba_timbersaw_timber_chain_claw"):Destroy()
				end
			end
		end
	end
end

function imba_timbersaw_timber_chain:OnProjectileHit_ExtraData(target, location, data)
	if not target then
		-- Yeah IDK how long it's supposed to last but it seems really short
		self:CreateVisibilityNode(location, 400, 0.1)

		self:GetCaster():EmitSound("Hero_Shredder.TimberChain.Retract")

		if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
			if not self.responses then
				self.responses =
				{
					["shredder_timb_failure_01"] = 0,
					["shredder_timb_failure_02"] = 0,
					["shredder_timb_failure_03"] = 0,
				}

				self.response_keys = {}

				for _, timer in pairs(self.responses) do
					table.insert(self.response_keys, _)
				end
			end

			self.random_selection = RandomInt(1, #self.response_keys)

			if GameRules:GetDOTATime(true, true) - self.responses[self.response_keys[self.random_selection]] >= 5 then
				self:GetCaster():EmitSound(self.response_keys[self.random_selection])
				self.responses[self.response_keys[self.random_selection]] = GameRules:GetDOTATime(true, true)
			end
		end

		if data.timber_particle and not self:GetCaster():HasModifier("modifier_imba_timbersaw_timber_chain") then
			ParticleManager:SetParticleControlEnt(data.timber_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true)
		end
	end
end

------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_TIMBER_CHAIN --
------------------------------------------

function modifier_imba_timbersaw_timber_chain:IsPurgable() return false end

function modifier_imba_timbersaw_timber_chain:RemoveOnDeath() return false end

function modifier_imba_timbersaw_timber_chain:GetEffectName()
	return "particles/units/heroes/hero_shredder/shredder_timber_chain_trail.vpcf"
end

function modifier_imba_timbersaw_timber_chain:OnCreated(params)
	if not IsServer() then return end

	self.autocast_state               = params.autocast_state
	self.damage_type                  = params.damage_type

	self.tree                         = EntIndexToHScript(params.tree_entindex)

	self.radius                       = params.radius
	self.speed                        = params.speed
	self.damage                       = params.damage
	self.whirling_chain_stat_loss_pct = params.whirling_chain_stat_loss_pct
	self.side_hooks_damage_reduction  = params.side_hooks_damage_reduction
	self.side_hooks_drag_pct          = params.side_hooks_drag_pct

	self.timber_particle              = params.timber_particle

	if self.autocast_state == 1 then
		self.damage = self.damage * self.side_hooks_damage_reduction / 100
	end

	self.distance        = (Vector(params.direction_x, params.direction_y, params.direction_z) - self:GetCaster():GetAbsOrigin()):Length2D()
	self.direction       = Vector(params.direction_x, params.direction_y, params.direction_z):Normalized()

	-- Velocity = Displacement/Time
	self.velocity        = self.direction * params.speed

	self.damaged_targets = {}

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function modifier_imba_timbersaw_timber_chain:OnDestroy()
	if not IsServer() then return end

	self:GetParent():InterruptMotionControllers(true)

	if self.tree and not self.tree:IsNull() then
		EmitSoundOnLocationWithCaster(self.tree:GetAbsOrigin(), "Hero_Shredder.TimberChain.Impact", self:GetCaster())

		self.tree_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_timber_chain_tree.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(self.tree_particle, 0, self.tree:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(self.tree_particle)

		if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
			self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
		end

		if self.tree.CutDown or (self.tree.Kill and not self.tree.HasModifier) then
			if self:GetCaster():GetName() == "npc_dota_hero_shredder" and RollPercentage(50) then
				if self:GetAbility() and not self:GetAbility().tree_responses then
					self:GetAbility().tree_responses =
					{
						"shredder_timb_timberchain_02",
						"shredder_timb_timberchain_04",
						"shredder_timb_timberchain_05",
						"shredder_timb_timberchain_07",
						"shredder_timb_timberchain_08",
						"shredder_timb_timberchain_09"
					}
				end

				self:GetCaster():EmitSound(self:GetAbility().tree_responses[RandomInt(1, #self:GetAbility().tree_responses)])
			end

			if self.tree.CutDown then
				self.tree:CutDown(self:GetParent():GetTeamNumber())
			elseif self.tree.Kill and not self.tree.HasModifier then
				self.tree:Kill()
			end

			if self.dendrophobia_modifier then
				self.dendrophobia_modifier:IncrementStackCount()
			end
		end
	end

	ParticleManager:DestroyParticle(self.timber_particle, true)
	ParticleManager:ReleaseParticleIndex(self.timber_particle)

	if self:GetCaster():GetTogglableWearable(DOTA_LOADOUT_TYPE_WEAPON) then
		self:GetCaster():GetTogglableWearable(DOTA_LOADOUT_TYPE_WEAPON):RemoveEffects(EF_NODRAW)
	end
end

function modifier_imba_timbersaw_timber_chain:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end

	-- If we go by the logic of Timbersaw porting along if die + buyback while chaining then the below may not be correct
	-- But it looks like vanilla Timber Chain has a duration so...
	me:SetOrigin(me:GetOrigin() + self.velocity * dt)

	for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
		if not self.damaged_targets[enemy] then
			enemy:EmitSound("Hero_Shredder.TimberChain.Damage")

			self.damage_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, enemy)
			ParticleManager:ReleaseParticleIndex(self.damage_particle)

			ApplyDamage({
				victim       = enemy,
				damage       = self.damage,
				damage_type  = self.damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetParent(),
				ability      = self:GetAbility()
			})

			self.damaged_targets[enemy] = true

			-- IMBAfication: Whirling Chain
			if self:GetAbility() and self:GetCaster():HasAbility("imba_timbersaw_whirling_death") then
				if not self:GetAbility().whirling_ability or self:GetAbility().whirling_ability:IsNull() then
					self:GetAbility().whirling_ability = self:GetCaster():FindAbilityByName("imba_timbersaw_whirling_death")
				end

				if self:GetAbility().whirling_ability then
					enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_timbersaw_whirling_death_debuff", {
						duration              = self:GetAbility().whirling_ability:GetSpecialValueFor("duration") * (1 - enemy:GetStatusResistance()),
						blood_oil_convert_pct = self:GetAbility().whirling_ability:GetSpecialValueFor("blood_oil_convert_pct"),
						blood_oil_duration    = self:GetAbility().whirling_ability:GetSpecialValueFor("blood_oil_duration"),
						stat_loss_pct         = self.whirling_chain_stat_loss_pct
					})
				end
			end

			-- IMBAfication: Side Hooks
			if self.autocast_state and self.autocast_state == 1 then
				local direction = (self.tree:GetAbsOrigin() - enemy:GetAbsOrigin()):Normalized()

				enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_timbersaw_timber_chain_side_hooks", {
					duration      = ((self.tree:GetAbsOrigin() - enemy:GetAbsOrigin()):Length2D() / self.speed) * self.side_hooks_drag_pct / 100 * (1 - enemy:GetStatusResistance()),
					direction_x   = direction.x,
					direction_y   = direction.y,
					direction_z   = direction.z,
					tree_entindex = self.tree:entindex(),
					speed         = self.speed
				})
			end
		end
	end

	if self:GetParent():IsStunned() or (self.tree:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetParent():GetHullRadius() then
		self:Destroy()
	end
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
-- Inconsistency with vanilla: Timbersaw can't blink while being pulled by Timber Chain in vanilla, but can here...
function modifier_imba_timbersaw_timber_chain:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_timbersaw_timber_chain:CheckState()
	return { [MODIFIER_STATE_DISARMED] = true }
end

-----------------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_TIMBER_CHAIN_SIDE_HOOKS --
-----------------------------------------------------

function modifier_imba_timbersaw_timber_chain_side_hooks:OnCreated(params)
	if not IsServer() then return end

	self.tree      = EntIndexToHScript(params.tree_entindex)
	self.speed     = params.speed

	self.distance  = (Vector(params.direction_x, params.direction_y, params.direction_z) - self:GetParent():GetAbsOrigin()):Length2D()
	self.direction = Vector(params.direction_x, params.direction_y, params.direction_z):Normalized()

	-- Velocity = Displacement/Time
	self.velocity  = self.direction * self.speed

	if self:ApplyHorizontalMotionController() == false then
		self:Destroy()
	end
end

function modifier_imba_timbersaw_timber_chain_side_hooks:OnDestroy()
	if not IsServer() then return end

	self:GetParent():InterruptMotionControllers(true)
end

function modifier_imba_timbersaw_timber_chain_side_hooks:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end

	me:SetOrigin(me:GetOrigin() + self.velocity * dt)

	if (self.tree:GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Length2D() <= self:GetParent():GetHullRadius() then
		self:Destroy()
	end
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_imba_timbersaw_timber_chain_side_hooks:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_timbersaw_timber_chain_side_hooks:CheckState()
	return { [MODIFIER_STATE_DISARMED] = true }
end

function modifier_imba_timbersaw_timber_chain_side_hooks:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_imba_timbersaw_timber_chain_side_hooks:GetOverrideAnimation(params)
	if self:GetParent():GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
		return ACT_DOTA_FLAIL
	end
end

-----------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_TIMBER_CHAIN_CLAW --
-----------------------------------------------

-- This is just to return the claw draw model back after a failed Timber Chain
function modifier_imba_timbersaw_timber_chain_claw:IsHidden() return true end

function modifier_imba_timbersaw_timber_chain_claw:IsPurgable() return false end

function modifier_imba_timbersaw_timber_chain_claw:RemoveOnDeath() return false end

function modifier_imba_timbersaw_timber_chain_claw:OnDestroy()
	if not IsServer() or self:GetRemainingTime() > 0 then return end

	if self:GetCaster():GetTogglableWearable(DOTA_LOADOUT_TYPE_WEAPON) then
		self:GetCaster():GetTogglableWearable(DOTA_LOADOUT_TYPE_WEAPON):RemoveEffects(EF_NODRAW)
	end
end

----------------------------------
-- IMBA_TIMBERSAW_REACTIVE_ARMOR --
----------------------------------

function imba_timbersaw_reactive_armor:GetIntrinsicModifierName()
	return "modifier_imba_timbersaw_reactive_armor"
end

-- IMBAfication: Emergency Bunker
function imba_timbersaw_reactive_armor:GetBehavior()
	-- return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
end

-- function imba_timbersaw_reactive_armor:GetCooldown(level)
-- return self:GetSpecialValueFor("emergency_bunker_debuff_cooldown")
-- end

-- function imba_timbersaw_reactive_armor:GetManaCost(level)
-- return self:GetSpecialValueFor("emergency_bunker_debuff_mana_cost")
-- end

-- Disabling Emergency Bunker with this line + commenting OnSpellStart out cause of potential lag issues
function imba_timbersaw_reactive_armor:OnAbilityPhaseStart()
	return false
end

-- TODO: Find particle effect + sound for Emergency Bunker IMBAfication
-- On second thought, this looks like it's gonna be way too god damn laggy due to mass modifier application...guess I should scrap this
-- function imba_timbersaw_reactive_armor:OnSpellStart()
-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_reactive_armor_debuff", {duration = self:GetSpecialValueFor("emergency_bunker_debuff_duration")})

-- for stack_num = 1, self:GetTalentSpecialValueFor("stack_limit") do
-- self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_reactive_armor_stack", {duration = self:GetSpecialValueFor("stack_duration")})
-- end

-- if not self.reactive_armor_modifier then
-- self.reactive_armor_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_reactive_armor", self:GetCaster())
-- end

-- if self.reactive_armor_modifier and not self.reactive_armor_modifier:IsNull() then
-- self.reactive_armor_modifier:SetDuration(self:GetSpecialValueFor("stack_duration"), true)
-- end
-- end

-------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_REACTIVE_ARMOR --
-------------------------------------------

function modifier_imba_timbersaw_reactive_armor:DestroyOnExpire() return false end

function modifier_imba_timbersaw_reactive_armor:IsHidden() return self:GetStackCount() == 0 end

function modifier_imba_timbersaw_reactive_armor:OnCreated()
	if not IsServer() then return end

	-- Set up all the armor pieces (this took longer than it should have to figure out, and maybe it's not even correct?)
	if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
		self.reactive_particle_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_armor_lyr1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.reactive_particle_1, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_armor", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.reactive_particle_1, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControlEnt(self.reactive_particle_1, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.reactive_particle_1, false, false, -1, false, false)

		self.reactive_particle_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_armor_lyr2.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.reactive_particle_2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_armor", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.reactive_particle_2, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControlEnt(self.reactive_particle_2, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.reactive_particle_2, false, false, -1, false, false)

		self.reactive_particle_3 = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_armor_lyr3.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.reactive_particle_3, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_armor", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.reactive_particle_3, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControlEnt(self.reactive_particle_3, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.reactive_particle_3, false, false, -1, false, false)

		self.reactive_particle_4 = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_armor_lyr4.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.reactive_particle_4, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_armor", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.reactive_particle_4, 2, Vector(0, 0, 0))
		ParticleManager:SetParticleControlEnt(self.reactive_particle_4, 4, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.reactive_particle_4, false, false, -1, false, false)
	end
end

-- IMBAfication: C'mon, HIT ME!
function modifier_imba_timbersaw_reactive_armor:CheckState()
	if self:GetAbility().GetAutoCastState and self:GetAbility():GetAutoCastState() then
		return { [MODIFIER_STATE_SPECIALLY_DENIABLE] = true }
	end
end

function modifier_imba_timbersaw_reactive_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,

		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE
	}
end

function modifier_imba_timbersaw_reactive_armor:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor") * self:GetStackCount()
end

function modifier_imba_timbersaw_reactive_armor:GetModifierConstantHealthRegen()
	return self:GetAbility():GetSpecialValueFor("bonus_hp_regen") * self:GetStackCount()
end

-- "Each successful attack on Timbersaw grants him 1 stack. The stack is added right before the attack's damage is applied."
-- ...I hope this is right?
function modifier_imba_timbersaw_reactive_armor:OnAttackLanded(keys)
	if keys.target == self:GetParent() and not self:GetParent():PassivesDisabled() and not self:GetParent():HasModifier("modifier_imba_timbersaw_reactive_armor_debuff") and self:GetAbility() and self:GetAbility():IsTrained() then
		self.reactive_hit_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_reactive_hit.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.reactive_hit_particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_chimmney", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:ReleaseParticleIndex(self.reactive_hit_particle)

		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_timbersaw_reactive_armor_stack", { duration = self:GetAbility():GetSpecialValueFor("stack_duration") })
		self:SetDuration(self:GetAbility():GetSpecialValueFor("stack_duration"), true)

		if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			for additional_stacks = 1, self:GetAbility():GetSpecialValueFor("ally_hit_additional_stacks") do
				self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_imba_timbersaw_reactive_armor_stack", { duration = self:GetAbility():GetSpecialValueFor("stack_duration") })
			end
		end
	end
end

function modifier_imba_timbersaw_reactive_armor:GetModifierIncomingPhysicalDamage_Percentage(keys)
	if self:GetAbility().GetAutoCastState and self:GetAbility():GetAutoCastState() and keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return self:GetAbility():GetSpecialValueFor("ally_damage_reduction") * (-1)
	end
end

-------------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_REACTIVE_ARMOR_STACK --
-------------------------------------------------

function modifier_imba_timbersaw_reactive_armor_stack:IsHidden() return true end

function modifier_imba_timbersaw_reactive_armor_stack:IsPurgable() return false end

function modifier_imba_timbersaw_reactive_armor_stack:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

-- The amount of stacks is also visually indicated by a dome which closes over on Timbersaw. The exhaust on the suit also starts emitting fire once the dome is fully closed.
-- The dome has 4 fragments, each appearing for every 4 stacks (1-4, 5-8, 9-12, 13-16). The dome opens again upon dropping below the given amount of stacks.
function modifier_imba_timbersaw_reactive_armor_stack:OnCreated()
	if not IsServer() then return end

	self.stack_limit             = self:GetAbility():GetTalentSpecialValueFor("stack_limit")

	self.min_stacks_particle_1   = 1
	self.min_stacks_particle_2   = 5
	self.min_stacks_particle_3   = 9
	self.min_stacks_particle_4   = 13

	self.reactive_armor_modifier = self:GetParent():FindModifierByNameAndCaster("modifier_imba_timbersaw_reactive_armor", self:GetCaster())

	if self.reactive_armor_modifier and not self.reactive_armor_modifier:IsNull() then
		if not self:GetCaster():HasModifier("modifier_imba_timbersaw_reactive_armor_debuff") then
			self.reactive_armor_modifier:SetStackCount(math.min(#self:GetParent():FindAllModifiersByName(self:GetName()), self.stack_limit))
		else
			self.reactive_armor_modifier:SetStackCount(#self:GetParent():FindAllModifiersByName(self:GetName()))
		end

		if self.reactive_armor_modifier.reactive_particle_1 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_1, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_1, 0, 0))
		end

		if self.reactive_armor_modifier.reactive_particle_2 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_2, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_2, 0, 0))
		end

		if self.reactive_armor_modifier.reactive_particle_3 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_3, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_3, 0, 0))
		end

		if self.reactive_armor_modifier.reactive_particle_4 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_4, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_4, 0, 0))
		end
	end
end

function modifier_imba_timbersaw_reactive_armor_stack:OnDestroy()
	if not IsServer() then return end

	if self.reactive_armor_modifier and not self.reactive_armor_modifier:IsNull() then
		if not self:GetCaster():HasModifier("modifier_imba_timbersaw_reactive_armor_debuff") then
			self.reactive_armor_modifier:SetStackCount(math.min(#self:GetParent():FindAllModifiersByName(self:GetName()), self.stack_limit))
		else
			self.reactive_armor_modifier:SetStackCount(#self:GetParent():FindAllModifiersByName(self:GetName()))
		end

		if self.reactive_armor_modifier.reactive_particle_1 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_1, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_1, 0, 0))
		end

		if self.reactive_armor_modifier.reactive_particle_2 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_2, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_2, 0, 0))
		end

		if self.reactive_armor_modifier.reactive_particle_3 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_3, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_3, 0, 0))
		end

		if self.reactive_armor_modifier.reactive_particle_4 then
			ParticleManager:SetParticleControl(self.reactive_armor_modifier.reactive_particle_4, 2, Vector(self.reactive_armor_modifier:GetStackCount() - self.min_stacks_particle_4, 0, 0))
		end
	end

	-- Technically you won't even see the modifier when it's at 0 stacks but w/e
	if self.reactive_armor_modifier:GetStackCount() == 0 then
		self.reactive_armor_modifier:SetDuration(-1, true)
	end
end

---------------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_REACTIVE_ARMOR_DEBUFF --
---------------------------------------------------

function modifier_imba_timbersaw_reactive_armor_debuff:IsDebuff() return true end

function modifier_imba_timbersaw_reactive_armor_debuff:IsPurgable() return false end

function modifier_imba_timbersaw_reactive_armor_debuff:RemoveOnDeath() return false end

-----------------------------
-- IMBA_TIMBERSAW_CHAKRAM_2 --
-----------------------------

-- Time for the world's worst copy-paste job

-- function imba_timbersaw_chakram_2:GetAssociatedSecondaryAbilities()
-- return "imba_timbersaw_return_chakram_2"
-- end

function imba_timbersaw_chakram_2:IsInnateAbility() return true end

function imba_timbersaw_chakram_2:ProcsMagicStick() return false end

function imba_timbersaw_chakram_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_timbersaw_chakram_2:OnInventoryContentsChanged()
	if self:GetCaster():HasScepter() or self:IsStolen() then
		if not self:IsTrained() then
			self:SetLevel(1)
		end

		if not self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2") or (self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden()) then
			self:SetHidden(false)
		end
	else
		if not self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2") or (self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden()) then
			self:SetHidden(true)
		end
	end
end

function imba_timbersaw_chakram_2:OnHeroCalculateStatBonus()
	self:OnInventoryContentsChanged()
end

function imba_timbersaw_chakram_2:OnStolen(self)
	if not self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") then
		self:GetCaster():AddAbility("imba_timbersaw_return_chakram_2"):SetHidden(true)
	end
end

-- SPAGHET
function imba_timbersaw_chakram_2:OnUnStolen()
	if self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") then
		if not self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden() then
			self:GetCaster():SwapAbilities(self:GetName(), "imba_timbersaw_return_chakram_2", true, false)
		end

		self:GetCaster():RemoveAbility("imba_timbersaw_return_chakram_2")

		if self.GetCaster and self:GetCaster() and self:GetCaster().RemoveModifierByName then
			self:GetCaster():RemoveModifierByName("modifier_imba_timbersaw_chakram_disarm")
		end
	end
end

function imba_timbersaw_chakram_2:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	if not self.projectiles then
		self.projectiles = {}
	end

	self:GetCaster():EmitSound("Hero_Shredder.Chakram.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
		if not self.responses then
			self.responses =
			{
				["shredder_timb_chakram_02"] = 0,
				["shredder_timb_chakram_03"] = 0,
				["shredder_timb_chakram_06"] = 0,
				["shredder_timb_chakram_07"] = 0,
				["shredder_timb_chakram_08"] = 0
			}

			self.response_keys = {}

			for _, timer in pairs(self.responses) do
				table.insert(self.response_keys, _)
			end
		end

		self.random_selection = RandomInt(1, #self.response_keys)

		if GameRules:GetDOTATime(true, true) - self.responses[self.response_keys[self.random_selection]] >= 5 then
			self:GetCaster():EmitSound(self.response_keys[self.random_selection])
			self.responses[self.response_keys[self.random_selection]] = GameRules:GetDOTATime(true, true)
		end
	end

	local ExtraData = {
		cast_pos_x     = self:GetCaster():GetAbsOrigin().x,
		cast_pos_y     = self:GetCaster():GetAbsOrigin().y,
		cast_pos_z     = self:GetCaster():GetAbsOrigin().z,
		bAutoCastState = self:GetAutoCastState()
	}

	if not self.effect_name then
		self.effect_name = "particles/units/heroes/hero_shredder/shredder_chakram_aghs.vpcf"

		if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand") then
			self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_aghs.vpcf"
		end
	end

	local chakram_projectile = ProjectileManager:CreateLinearProjectile({
		Source           = self:GetCaster(),
		Ability          = self,
		vSpawnOrigin     = self:GetCaster():GetAbsOrigin(),
		bDeleteOnHit     = false,
		EffectName       = self.effect_name,
		fDistance        = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D(),
		vVelocity        = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0),
		fStartRadius     = self:GetSpecialValueFor("radius"),
		fEndRadius       = self:GetSpecialValueFor("radius"),
		iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bHasFrontalCone  = false,
		bReplaceExisting = false,
		fExpireTime      = GameRules:GetGameTime() + 10.0,
		-- "Chakram provides 300 radius flying vision while spinning in place at the target area (but not while traveling)."
		bProvidesVision  = false,
		ExtraData        = ExtraData
	})

	self.projectiles[chakram_projectile] = ExtraData

	if not self:IsHidden() and self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden() then
		if self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):GetLevel() ~= self:GetLevel() then
			self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):SetLevel(self:GetLevel())
		end

		self:GetCaster():SwapAbilities(self:GetName(), "imba_timbersaw_return_chakram_2", false, true)
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_disarm", {})
end

function imba_timbersaw_chakram_2:OnProjectileThinkHandle(projectileHandle)
	if #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), true) >= 1 then
		for _, tree in pairs(GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)) do
			EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Hero_Shredder.Chakram.Tree", self:GetCaster())
		end

		if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
			self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
		end

		if self.dendrophobia_modifier then
			self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false))
		end

		GridNav:DestroyTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)
	end
end

-- This is for the returning chakram logic (tracking projectile to caster)
-- It looks like this function always runs after the "OnProjectileThinkHandle()" function above so I'm gonna do something a bit hacker to get the projectileID of tracking projectiles (cause otherwise it doesn't provide a reference to it on its own creation...)
function imba_timbersaw_chakram_2:OnProjectileThink_ExtraData(location, data)
	if data.bReturning then
		if #GridNav:GetAllTreesAroundPoint(location, self:GetSpecialValueFor("radius"), true) >= 1 then
			for _, tree in pairs(GridNav:GetAllTreesAroundPoint(location, self:GetSpecialValueFor("radius"), false)) do
				EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Hero_Shredder.Chakram.Tree", self:GetCaster())
			end

			if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
				self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
			end

			if self.dendrophobia_modifier then
				self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #GridNav:GetAllTreesAroundPoint(location, self:GetSpecialValueFor("radius"), false))
			end

			GridNav:DestroyTreesAroundPoint(location, self:GetSpecialValueFor("radius"), false)
		end

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if self.projectiles[data.id] and not self.projectiles[data.id].returning_enemies then
				self.projectiles[data.id].returning_enemies = {}
			end

			if self.projectiles[data.id].returning_enemies and not self.projectiles[data.id].returning_enemies[enemy] then
				enemy:EmitSound("Hero_Shredder.Chakram.Target")

				ApplyDamage({
					victim       = enemy,
					damage       = self:GetSpecialValueFor("pass_damage"),
					damage_type  = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self
				})

				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_debuff", { duration = self:GetSpecialValueFor("pass_slow_duration") * (1 - enemy:GetStatusResistance()) })

				self.projectiles[data.id].returning_enemies[enemy] = true
			end
		end
	end
end

-- This is for the launching chakram logic (linear projectile)
function imba_timbersaw_chakram_2:OnProjectileHitHandle(target, location, projectileHandle)
	if target and target ~= self:GetCaster() then
		if not self.projectiles[projectileHandle].launching_enemies then
			self.projectiles[projectileHandle].launching_enemies = {}
		end

		if self.projectiles[projectileHandle].launching_enemies and not self.projectiles[projectileHandle].launching_enemies[enemy] then
			target:EmitSound("Hero_Shredder.Chakram.Target")

			-- "A passing Chakram first applies the passing damage, then the debuff."
			ApplyDamage({
				victim       = target,
				damage       = self:GetSpecialValueFor("pass_damage"),
				damage_type  = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			})

			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_debuff", { duration = self:GetSpecialValueFor("pass_slow_duration") * (1 - target:GetStatusResistance()) })

			self.projectiles[projectileHandle].launching_enemies[target] = true
		end
	elseif not target and self.projectiles and self.projectiles[projectileHandle] then
		local auto_cast_flag = 0

		if self.projectiles[projectileHandle].bAutoCastState then
			auto_cast_flag = 1
		end

		CreateModifierThinker(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_thinker", {
				bAutoCastState     = auto_cast_flag,
				cast_pos_x         = self.projectiles[projectileHandle].cast_pos_x,
				cast_pos_y         = self.projectiles[projectileHandle].cast_pos_y,
				cast_pos_z         = self.projectiles[projectileHandle].cast_pos_z,
				speed              = self:GetSpecialValueFor("speed"),
				radius             = self:GetSpecialValueFor("radius"),
				damage_per_second  = self:GetSpecialValueFor("damage_per_second"),
				pass_damage        = self:GetSpecialValueFor("pass_damage"),
				damage_interval    = self:GetSpecialValueFor("damage_interval"),
				break_distance     = self:GetSpecialValueFor("break_distance"),
				mana_per_second    = self:GetSpecialValueFor("mana_per_second"),
				observe_tick_scale = self:GetSpecialValueFor("observe_tick_scale"),
				observe_max_scale  = self:GetSpecialValueFor("observe_max_scale"),
			},
			GetGroundPosition(location, nil), self:GetCaster():GetTeamNumber(), false)

		-- Remove projectile reference from table when the Chakram has fully launched
		self.projectiles[projectileHandle] = nil
	end
end

function imba_timbersaw_chakram_2:OnProjectileHit_ExtraData(target, location, data)
	if target and target == self:GetCaster() and data.bReturning then
		-- Remove appropriate projectile reference from table when the Chakram has fully returned
		if self.projectiles and self.projectiles[data.id] then
			self.projectiles[data.id] = nil
		end

		if self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") and not self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden() and self:IsHidden() then
			self:GetCaster():SwapAbilities(self:GetName(), "imba_timbersaw_return_chakram_2", true, false)
		end

		-- Remove disarm debuff if all Chakrams have returned
		if (not self:GetCaster():HasAbility("imba_timbersaw_return_chakram") or (self:GetCaster():HasAbility("imba_timbersaw_return_chakram") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):IsHidden()))
			and
			(not self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") or (self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden()))
			and
			self:GetCaster():HasModifier("modifier_imba_timbersaw_chakram_disarm") then
			self:GetCaster():RemoveModifierByName("modifier_imba_timbersaw_chakram_disarm")
		end
	end
end

---------------------------
-- IMBA_TIMBERSAW_CHAKRAM --
---------------------------

-- function imba_timbersaw_chakram:GetAssociatedSecondaryAbilities()
-- return "imba_timbersaw_return_chakram"
-- end

function imba_timbersaw_chakram:OnStolen(self)
	if not self:GetCaster():HasAbility("imba_timbersaw_return_chakram") then
		self:GetCaster():AddAbility("imba_timbersaw_return_chakram"):SetHidden(true)
	end
end

-- SPAGHET
function imba_timbersaw_chakram:OnUnStolen()
	if self:GetCaster():HasAbility("imba_timbersaw_return_chakram") then
		if not self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):IsHidden() then
			self:GetCaster():SwapAbilities(self:GetName(), "imba_timbersaw_return_chakram", true, false)
		end

		self:GetCaster():RemoveAbility("imba_timbersaw_return_chakram")

		if self.GetCaster and self:GetCaster() and self:GetCaster().RemoveModifierByName then
			self:GetCaster():RemoveModifierByName("modifier_imba_timbersaw_chakram_disarm")
		end
	end
end

function imba_timbersaw_chakram:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_timbersaw_chakram:OnUpgrade()
	if self:GetCaster():HasAbility("imba_timbersaw_chakram_2") and self:GetCaster():FindAbilityByName("imba_timbersaw_chakram_2"):GetLevel() ~= self:GetLevel() then
		self:GetCaster():FindAbilityByName("imba_timbersaw_chakram_2"):SetLevel(self:GetLevel())
	end

	if self:GetCaster():HasAbility("imba_timbersaw_chakram_3") and self:GetCaster():FindAbilityByName("imba_timbersaw_chakram_3"):GetLevel() ~= self:GetLevel() then
		self:GetCaster():FindAbilityByName("imba_timbersaw_chakram_3"):SetLevel(self:GetLevel())
	end
end

function imba_timbersaw_chakram:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	if not self.projectiles then
		self.projectiles = {}
	end

	self:GetCaster():EmitSound("Hero_Shredder.Chakram.Cast")

	if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
		if not self.responses then
			self.responses =
			{
				["shredder_timb_chakram_02"] = 0,
				["shredder_timb_chakram_03"] = 0,
				["shredder_timb_chakram_06"] = 0,
				["shredder_timb_chakram_07"] = 0,
				["shredder_timb_chakram_08"] = 0
			}

			self.response_keys = {}

			for _, timer in pairs(self.responses) do
				table.insert(self.response_keys, _)
			end
		end

		self.random_selection = RandomInt(1, #self.response_keys)

		if GameRules:GetDOTATime(true, true) - self.responses[self.response_keys[self.random_selection]] >= 5 then
			self:GetCaster():EmitSound(self.response_keys[self.random_selection])
			self.responses[self.response_keys[self.random_selection]] = GameRules:GetDOTATime(true, true)
		end
	end

	local ExtraData = {
		-- chakram_particle = chakram_particle,
		cast_pos_x     = self:GetCaster():GetAbsOrigin().x,
		cast_pos_y     = self:GetCaster():GetAbsOrigin().y,
		cast_pos_z     = self:GetCaster():GetAbsOrigin().z,
		bAutoCastState = self:GetAutoCastState()
	}

	if not self.effect_name then
		self.effect_name = "particles/units/heroes/hero_shredder/shredder_chakram.vpcf"

		if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand") then
			self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold.vpcf"
		end
	end

	local chakram_projectile = ProjectileManager:CreateLinearProjectile({
		Source           = self:GetCaster(),
		Ability          = self,
		vSpawnOrigin     = self:GetCaster():GetAbsOrigin(),
		bDeleteOnHit     = false,
		EffectName       = self.effect_name,
		fDistance        = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Length2D(),
		vVelocity        = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0),
		fStartRadius     = self:GetSpecialValueFor("radius"),
		fEndRadius       = self:GetSpecialValueFor("radius"),
		iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bHasFrontalCone  = false,
		bReplaceExisting = false,
		fExpireTime      = GameRules:GetGameTime() + 10.0,
		-- "Chakram provides 300 radius flying vision while spinning in place at the target area (but not while traveling)."
		bProvidesVision  = false,
		ExtraData        = ExtraData
	})

	self.projectiles[chakram_projectile] = ExtraData

	if not self:IsHidden() and self:GetCaster():HasAbility("imba_timbersaw_return_chakram") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):IsHidden() then
		if self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):GetLevel() ~= self:GetLevel() then
			self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):SetLevel(self:GetLevel())
		end

		self:GetCaster():SwapAbilities(self:GetName(), "imba_timbersaw_return_chakram", false, true)
	end

	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_disarm", {})
end

function imba_timbersaw_chakram:OnProjectileThinkHandle(projectileHandle)
	if #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), true) >= 1 then
		for _, tree in pairs(GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)) do
			EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Hero_Shredder.Chakram.Tree", self:GetCaster())
		end

		if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
			self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
		end

		if self.dendrophobia_modifier then
			self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false))
		end

		GridNav:DestroyTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)
	end
end

-- This is for the returning chakram logic (tracking projectile to caster)
-- It looks like this function always runs after the "OnProjectileThinkHandle()" function above so I'm gonna do something a bit hacker to get the projectileID of tracking projectiles (cause otherwise it doesn't provide a reference to it on its own creation...)
function imba_timbersaw_chakram:OnProjectileThink_ExtraData(location, data)
	if data.bReturning then
		if #GridNav:GetAllTreesAroundPoint(location, self:GetSpecialValueFor("radius"), true) >= 1 then
			for _, tree in pairs(GridNav:GetAllTreesAroundPoint(location, self:GetSpecialValueFor("radius"), false)) do
				EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Hero_Shredder.Chakram.Tree", self:GetCaster())
			end

			if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
				self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
			end

			if self.dendrophobia_modifier then
				self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #GridNav:GetAllTreesAroundPoint(location, self:GetSpecialValueFor("radius"), false))
			end

			GridNav:DestroyTreesAroundPoint(location, self:GetSpecialValueFor("radius"), false)
		end

		for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), location, nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
			if self.projectiles[data.id] and not self.projectiles[data.id].returning_enemies then
				self.projectiles[data.id].returning_enemies = {}
			end

			if self.projectiles[data.id].returning_enemies and not self.projectiles[data.id].returning_enemies[enemy] then
				enemy:EmitSound("Hero_Shredder.Chakram.Target")

				ApplyDamage({
					victim       = enemy,
					damage       = self:GetSpecialValueFor("pass_damage"),
					damage_type  = self:GetAbilityDamageType(),
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self
				})

				enemy:AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_debuff", { duration = self:GetSpecialValueFor("pass_slow_duration") * (1 - enemy:GetStatusResistance()) })

				self.projectiles[data.id].returning_enemies[enemy] = true
			end
		end
	end
end

-- This is for the launching chakram logic (linear projectile)
function imba_timbersaw_chakram:OnProjectileHitHandle(target, location, projectileHandle)
	if target and target ~= self:GetCaster() then
		if not self.projectiles[projectileHandle].launching_enemies then
			self.projectiles[projectileHandle].launching_enemies = {}
		end

		if self.projectiles[projectileHandle].launching_enemies and not self.projectiles[projectileHandle].launching_enemies[enemy] then
			target:EmitSound("Hero_Shredder.Chakram.Target")

			-- "A passing Chakram first applies the passing damage, then the debuff."
			ApplyDamage({
				victim       = target,
				damage       = self:GetSpecialValueFor("pass_damage"),
				damage_type  = self:GetAbilityDamageType(),
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker     = self:GetCaster(),
				ability      = self
			})

			target:AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_debuff", { duration = self:GetSpecialValueFor("pass_slow_duration") * (1 - target:GetStatusResistance()) })

			self.projectiles[projectileHandle].launching_enemies[target] = true
		end
	elseif not target and self.projectiles and self.projectiles[projectileHandle] then
		local auto_cast_flag = 0

		if self.projectiles[projectileHandle].bAutoCastState then
			auto_cast_flag = 1
		end

		CreateModifierThinker(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_thinker", {
				bAutoCastState     = auto_cast_flag,
				cast_pos_x         = self.projectiles[projectileHandle].cast_pos_x,
				cast_pos_y         = self.projectiles[projectileHandle].cast_pos_y,
				cast_pos_z         = self.projectiles[projectileHandle].cast_pos_z,
				speed              = self:GetSpecialValueFor("speed"),
				radius             = self:GetSpecialValueFor("radius"),
				damage_per_second  = self:GetSpecialValueFor("damage_per_second"),
				pass_damage        = self:GetSpecialValueFor("pass_damage"),
				damage_interval    = self:GetSpecialValueFor("damage_interval"),
				break_distance     = self:GetSpecialValueFor("break_distance"),
				mana_per_second    = self:GetSpecialValueFor("mana_per_second"),
				observe_tick_scale = self:GetSpecialValueFor("observe_tick_scale"),
				observe_max_scale  = self:GetSpecialValueFor("observe_max_scale"),
			},
			GetGroundPosition(location, nil), self:GetCaster():GetTeamNumber(), false)

		-- Remove projectile reference from table when the Chakram has fully launched
		self.projectiles[projectileHandle] = nil
	end
end

function imba_timbersaw_chakram:OnProjectileHit_ExtraData(target, location, data)
	if target and target == self:GetCaster() and data.bReturning then
		-- Remove appropriate projectile reference from table when the Chakram has fully returned
		if self.projectiles and self.projectiles[data.id] then
			self.projectiles[data.id] = nil
		end

		if self:GetCaster():HasAbility("imba_timbersaw_return_chakram") and not self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):IsHidden() and self:IsHidden() then
			self:GetCaster():SwapAbilities(self:GetName(), "imba_timbersaw_return_chakram", true, false)
		end

		-- Remove disarm debuff if all Chakrams have returned
		if (not self:GetCaster():HasAbility("imba_timbersaw_return_chakram") or (self:GetCaster():HasAbility("imba_timbersaw_return_chakram") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram"):IsHidden()))
			and
			(not self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") or (self:GetCaster():HasAbility("imba_timbersaw_return_chakram_2") and self:GetCaster():FindAbilityByName("imba_timbersaw_return_chakram_2"):IsHidden()))
			and
			self:GetCaster():HasModifier("modifier_imba_timbersaw_chakram_disarm") then
			self:GetCaster():RemoveModifierByName("modifier_imba_timbersaw_chakram_disarm")
		end
	end
end

----------------------------------
-- IMBA_TIMBERSAW_RETURN_CHAKRAM --
----------------------------------

function imba_timbersaw_return_chakram:GetAssociatedPrimaryAbilities()
	return "imba_timbersaw_chakram"
end

function imba_timbersaw_return_chakram:ProcsMagicStick() return false end

function imba_timbersaw_return_chakram:IsStealable() return false end

function imba_timbersaw_return_chakram:OnSpellStart()
	if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
		if not self.responses then
			self.responses =
			{
				["shredder_timb_chakramreturn_03"] = 0,
				["shredder_timb_chakramreturn_04"] = 0,
				["shredder_timb_chakramreturn_05"] = 0
			}

			self.response_keys = {}

			for _, timer in pairs(self.responses) do
				table.insert(self.response_keys, _)
			end
		end

		self.random_selection = RandomInt(1, #self.response_keys)

		if GameRules:GetDOTATime(true, true) - self.responses[self.response_keys[self.random_selection]] >= 5 then
			self:GetCaster():EmitSound(self.response_keys[self.random_selection])
			self.responses[self.response_keys[self.random_selection]] = GameRules:GetDOTATime(true, true)
		end
	end

	if not self.chakram_ability then
		self.chakram_ability = self:GetCaster():FindAbilityByName("imba_timbersaw_chakram")
	end

	if self.chakram_ability and self.chakram_ability.projectiles then
		for _, data in pairs(self.chakram_ability.projectiles) do
			-- Okay so the point of this is that it allows you to pull launching chakrams back before they've settled and actually put down those aura thinkers
			-- I need the weird "ProjectileManager:GetLinearProjectileRadius(_) == self.chakram_ability:GetSpecialValueFor("radius")" line because it's getting the linear projectile location of tracking projectiles somehow, which starts duplicating returning chakrams in a weird nearby place
			if ProjectileManager:GetLinearProjectileLocation(_) and ProjectileManager:GetLinearProjectileRadius(_) == self.chakram_ability:GetSpecialValueFor("radius") then
				local ExtraData = {
					bReturning = true,
					id         = GameRules:GetGameTime() -- Tracking Projectiles don't create their own ids so gonna do some spaghet method
				}

				if not self.effect_name then
					self.effect_name = "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf"

					if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand") then
						self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_return.vpcf"
						-- self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_return.vpcf"
					end

					-- if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand_blade_gold.vmdl") then
					-- effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_return.vpcf"
					-- end
				end

				local chakram_projectile = ProjectileManager:CreateTrackingProjectile({
					Target            = self:GetCaster(),
					Source            = nil,
					Ability           = self.chakram_ability,
					EffectName        = self.effect_name,
					iMoveSpeed        = self.chakram_ability:GetSpecialValueFor("speed"),
					vSourceLoc        = ProjectileManager:GetLinearProjectileLocation(_),
					bDrawsOnMinimap   = false,
					bDodgeable        = false,
					bIsAttack         = false,
					bVisibleToEnemies = true,
					bReplaceExisting  = false,
					-- flExpireTime 		= GameRules:GetGameTime() + 20.0,
					bProvidesVision   = false,
					ExtraData         = ExtraData
				})

				self.chakram_ability.projectiles[GameRules:GetGameTime()] = ExtraData

				ProjectileManager:DestroyLinearProjectile(_)
				self.chakram_ability.projectiles[_] = nil
			end
		end
	end
end

-------------------------------------
-- IMBA_TIMBERSAW_RETURN_CHAKRAM_2 --
------------------------------------

function imba_timbersaw_return_chakram_2:GetAssociatedPrimaryAbilities()
	return "imba_timbersaw_chakram_2"
end

function imba_timbersaw_return_chakram_2:IsStealable() return false end

function imba_timbersaw_return_chakram_2:OnSpellStart()
	if self:GetCaster():GetName() == "npc_dota_hero_shredder" then
		if not self.responses then
			self.responses =
			{
				["shredder_timb_chakramreturn_03"] = 0,
				["shredder_timb_chakramreturn_04"] = 0,
				["shredder_timb_chakramreturn_05"] = 0
			}

			self.response_keys = {}

			for _, timer in pairs(self.responses) do
				table.insert(self.response_keys, _)
			end
		end

		self.random_selection = RandomInt(1, #self.response_keys)

		if GameRules:GetDOTATime(true, true) - self.responses[self.response_keys[self.random_selection]] >= 5 then
			self:GetCaster():EmitSound(self.response_keys[self.random_selection])
			self.responses[self.response_keys[self.random_selection]] = GameRules:GetDOTATime(true, true)
		end
	end

	if not self.chakram_ability then
		self.chakram_ability = self:GetCaster():FindAbilityByName("imba_timbersaw_chakram_2")
	end

	if self.chakram_ability then
		for _, data in pairs(self.chakram_ability.projectiles) do
			-- Okay so the point of this is that it allows you to pull launching chakrams back before they've settled and actually put down those aura thinkers
			-- I need the weird "ProjectileManager:GetLinearProjectileRadius(_) == self.chakram_ability:GetSpecialValueFor("radius")" line because it's getting the linear projectile location of tracking projectiles somehow, which starts duplicating returning chakrams in a weird nearby place
			if ProjectileManager:GetLinearProjectileLocation(_) and ProjectileManager:GetLinearProjectileRadius(_) == self.chakram_ability:GetSpecialValueFor("radius") then
				local ExtraData = {
					bReturning = true,
					id         = GameRules:GetGameTime() -- Tracking Projectiles don't create their own ids so gonna do some spaghet method
				}

				if not self.effect_name then
					self.effect_name = "particles/econ/items/shredder/hero_shredder_icefx/shredder_chakram_return_ice.vpcf"

					if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand") then
						self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_return.vpcf"
						-- self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_return.vpcf"
						-- self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_aghs.vpcf"
					end

					-- if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand_blade_gold.vmdl") then
					-- effect_name = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_return.vpcf"
					-- end
				end

				local chakram_projectile = ProjectileManager:CreateTrackingProjectile({
					Target            = self:GetCaster(),
					Source            = nil,
					Ability           = self.chakram_ability,
					EffectName        = self.effect_name,
					iMoveSpeed        = self.chakram_ability:GetSpecialValueFor("speed"),
					vSourceLoc        = ProjectileManager:GetLinearProjectileLocation(_),
					bDrawsOnMinimap   = false,
					bDodgeable        = false,
					bIsAttack         = false,
					bVisibleToEnemies = true,
					bReplaceExisting  = false,
					-- flExpireTime 		= GameRules:GetGameTime() + 20.0,
					bProvidesVision   = false,
					ExtraData         = ExtraData
				})

				self.chakram_ability.projectiles[GameRules:GetGameTime()] = ExtraData

				ProjectileManager:DestroyLinearProjectile(_)
				self.chakram_ability.projectiles[_] = nil
			end
		end
	end
end

---------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_CHAKRAM_THINKER --
---------------------------------------------

function modifier_imba_timbersaw_chakram_thinker:IsPurgable() return false end

function modifier_imba_timbersaw_chakram_thinker:RemoveOnDeath() return false end

-- Three states possible for Chakram (well there will actually be four here but that's for later...)
-- - 1. Launching (use linear projectile?)
-- - 2. Lingering (use aura thinker?)
-- - 3. Returning (use tracking projectile?)

function modifier_imba_timbersaw_chakram_thinker:OnCreated(params)
	if self:GetAbility() then
		self.speed              = self:GetAbility():GetSpecialValueFor("speed")
		self.radius             = self:GetAbility():GetSpecialValueFor("radius")
		self.damage_per_second  = self:GetAbility():GetSpecialValueFor("damage_per_second")
		self.pass_damage        = self:GetAbility():GetSpecialValueFor("pass_damage")
		self.damage_interval    = self:GetAbility():GetSpecialValueFor("damage_interval")
		self.break_distance     = self:GetAbility():GetSpecialValueFor("break_distance")
		self.mana_per_second    = self:GetAbility():GetSpecialValueFor("mana_per_second")
		self.observe_tick_scale = self:GetAbility():GetSpecialValueFor("observe_tick_scale")
		self.observe_max_scale  = self:GetAbility():GetSpecialValueFor("observe_max_scale")
	elseif not self:GetAbility() and IsServer() then
		self.speed              = params.speed
		self.radius             = params.radius
		self.damage_per_second  = params.damage_per_second
		self.pass_damage        = params.pass_damage
		self.damage_interval    = params.damage_interval
		self.break_distance     = params.break_distance
		self.mana_per_second    = params.mana_per_second
		self.observe_tick_scale = params.observe_tick_scale
		self.observe_max_scale  = params.observe_max_scale
	end

	if not IsServer() then return end

	if self:GetAbility() then
		self.damage_type = self:GetAbility():GetAbilityDamageType()

		self.effect_name = "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf"

		if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand") then
			self.effect_name = "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_return.vpcf"
		elseif self:GetAbility():GetName() == "imba_timbersaw_chakram_2" then
			self.effect_name = "particles/econ/items/shredder/hero_shredder_icefx/shredder_chakram_return_ice.vpcf"
		end
	else
		self.damage_type = DAMAGE_TYPE_PURE
	end

	self:GetParent():EmitSound("Hero_Shredder.Chakram")

	if params.bAutoCastState and params.bAutoCastState == 1 then
		-- -- Was trying to do some fancy stuff with moving Chakrams on auto-cast but the particles and motion controllers didn't play nice so I guess I gotta switch it up...
		-- self.interval	= FrameTime()
		-- -- Initialize some extra variables to deal with the FrameTime() interval think (man I hope this doesn't lag to death but I'm not optimistic)
		-- self.counter	= self.interval
		-- self.damaged_targets	= {}

		-- self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)

		-- -- Honestly all three of these particles don't really work properly with what I'm trying, but this is argubaly the lesser evil
		-- -- Stationary chakram can't attach to moving units to have the particle move itself
		-- -- Launching chakram can't have its direction change in the OnIntervalThink() or any time right after it's created
		-- -- Returning chakram goes vertical if it reaches its target which basically needs to be always in this scenario (this is the one used)
		-- self.chakram_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControlEnt(self.chakram_particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetAbsOrigin(), true)
		-- -- Arbitrary fast speed for the model to keep up with the thinker's movement
		-- ParticleManager:SetParticleControl(self.chakram_particle, 2, Vector(3000, 0, 0 ))

		-- self:AddParticle(self.chakram_particle, false, false, -1, false, false)


		-- self.cast_pos = Vector(params.cast_pos_x, params.cast_pos_y, params.cast_pos_z)

		-- self.circumference	= 2 * math.pi * (self:GetParent():GetAbsOrigin() - self.cast_pos):Length2D() * 0.5
		-- self.angle			=  ((self.speed * 0.5) / self.circumference) * 360

		-- if self:ApplyHorizontalMotionController() == false then
		-- self:Destroy()
		-- end
	else
		-- self.interval = self.damage_interval

		-- self.chakram_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shredder/shredder_chakram_stay.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- self:AddParticle(self.chakram_particle, false, false, -1, false, false)
	end

	self.interval = self.damage_interval

	self.stay_effect = "particles/units/heroes/hero_shredder/shredder_chakram_stay.vpcf"

	if Wearables:GetWearable(self:GetCaster(), "models/items/shredder/timbersaw_ti9_immortal_offhand/timbersaw_ti9_immortal_offhand") then
		self.stay_effect = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold_stay.vpcf"
	end

	self.chakram_particle = ParticleManager:CreateParticle(self.stay_effect, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())

	-- Because they share the same particle with just different CPs for colours, this needs to be established here
	if self:GetAbility() then
		if self:GetAbility():GetName() == "imba_timbersaw_chakram" then
			if self:GetAbility():GetAutoCastState() then
				self:GetParent().bTimberChainTarget = true
				ParticleManager:SetParticleControl(self.chakram_particle, 15, Vector(255, 255, 255))
				ParticleManager:SetParticleControl(self.chakram_particle, 16, Vector(1, 0, 0))
			else
				ParticleManager:SetParticleControl(self.chakram_particle, 16, Vector(0, 0, 0))
			end
		elseif self:GetAbility():GetName() == "imba_timbersaw_chakram_2" then
			if self:GetAbility():GetAutoCastState() then
				self:GetParent().bTimberChainTarget = true
				ParticleManager:SetParticleControl(self.chakram_particle, 15, Vector(128, 128, 255))
				ParticleManager:SetParticleControl(self.chakram_particle, 60, Vector(255, 255, 255))
				ParticleManager:SetParticleControl(self.chakram_particle, 61, Vector(1, 0, 0))
			else
				ParticleManager:SetParticleControl(self.chakram_particle, 15, Vector(0, 0, 255))
			end

			ParticleManager:SetParticleControl(self.chakram_particle, 16, Vector(1, 0, 0))
		end
	end

	self:AddParticle(self.chakram_particle, false, false, -1, false, false)

	self:StartIntervalThink(self.interval)
end

function modifier_imba_timbersaw_chakram_thinker:OnIntervalThink()
	--if not self:GetAbility() or not self:GetCaster():IsAlive() then self:Destroy() return end
	if not self:GetAbility() then
		self:Destroy()
		return
	end

	if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
		self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
	end

	if self.dendrophobia_modifier then
		self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #GridNav:GetAllTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetParent():GetHullRadius(), false))
	end

	GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), self:GetParent():GetHullRadius(), true)

	if self.interval == self.damage_interval or (self.interval ~= self.damage_interval and self.counter >= self.damage_interval) then
		-- Issue: This doesn't account for mana-reduction values when checking if there's enough mana for Chakram to be sustained
		if self:GetCaster():GetMana() >= self.mana_per_second and (self:GetParent():GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.break_distance then
			self:GetCaster():ReduceMana(self.mana_per_second)

			for _, enemy in pairs(FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do
				-- if not self.counter then
				ApplyDamage({
					victim       = enemy,
					-- IMBAfication: Observe and Improve
					damage       = self.damage_per_second * (1 + math.min(self.observe_tick_scale * (self:GetElapsedTime() / self.damage_interval) / 100, self.observe_max_scale / 100)),
					damage_type  = self.damage_type,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					attacker     = self:GetCaster(),
					ability      = self:GetAbility()
				})
				-- elseif not self.damaged_targets[enemy] or GameRules:GetDOTATime(true, true) - self.damaged_targets[enemy] >= self.damage_interval then
				-- ApplyDamage({
				-- victim 			= enemy,
				-- damage 			= self.pass_damage,
				-- damage_type		= self.damage_type,
				-- damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				-- attacker 		= self:GetCaster(),
				-- ability 		= self:GetAbility()
				-- })

				-- self.damaged_targets[enemy] = GameRules:GetDOTATime(true, true)
				-- end
			end
		else
			self:Destroy()
		end

		if self.counter then
			self.counter = 0
		end
	elseif self.counter then
		self.counter = self.counter + self.interval
	end

	if self.counter ~= nil then
		self:GetParent():SetOrigin(RotatePosition(self.cast_pos, QAngle(0, self.angle * self.interval, 0), self:GetParent():GetOrigin()))
	end
end

function modifier_imba_timbersaw_chakram_thinker:OnDestroy()
	if not IsServer() then return end

	self:GetParent():StopSound("Hero_Shredder.Chakram")
	EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_Shredder.Chakram.Return", self:GetCaster())

	self:GetParent():InterruptMotionControllers(true)

	if self:GetAbility() then
		local ExtraData                                        = {
			bReturning = true,
			id         = GameRules:GetGameTime() -- Tracking Projectiles don't create their own ids so gonna do some spaghet method
		}

		local chakram_projectile                               = ProjectileManager:CreateTrackingProjectile({
			Target            = self:GetCaster(),
			Source            = self:GetParent(),
			Ability           = self:GetAbility(),
			EffectName        = self.effect_name or "particles/units/heroes/hero_shredder/shredder_chakram_return.vpcf",
			iMoveSpeed        = self.speed,
			vSourceLoc        = self:GetParent():GetAbsOrigin(),
			bDrawsOnMinimap   = false,
			bDodgeable        = false,
			bIsAttack         = false,
			bVisibleToEnemies = true,
			bReplaceExisting  = false,
			-- flExpireTime 		= GameRules:GetGameTime() + 20.0,
			bProvidesVision   = false,
			ExtraData         = ExtraData
		})

		self:GetAbility().projectiles[GameRules:GetGameTime()] = ExtraData
	end
end

-- This function won't run for some reason so I'm swapping to the intervalthink (hopefully won't be laggy as hell -_-)
function modifier_imba_timbersaw_chakram_thinker:UpdateHorizontalMotion(me, dt)
	if not IsServer() then return end

	-- me:SetOrigin(RotatePosition(self.cast_pos, QAngle(0, self.angle * dt, 0), me:GetOrigin()))
end

-- This typically gets called if the caster uses a position breaking tool (ex. Blink Dagger) while in mid-motion
function modifier_imba_timbersaw_chakram_thinker:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_imba_timbersaw_chakram_thinker:CheckState()
	return { [MODIFIER_STATE_PROVIDES_VISION] = true }
end

function modifier_imba_timbersaw_chakram_thinker:DeclareFunctions()
	return { MODIFIER_PROPERTY_BONUS_DAY_VISION, MODIFIER_PROPERTY_BONUS_NIGHT_VISION, MODIFIER_EVENT_ON_ABILITY_FULLY_CAST }
end

function modifier_imba_timbersaw_chakram_thinker:GetBonusDayVision()
	return 300
end

function modifier_imba_timbersaw_chakram_thinker:GetBonusNightVision()
	return 300
end

function modifier_imba_timbersaw_chakram_thinker:OnAbilityFullyCast(keys)
	if keys.unit == self:GetCaster() and self:GetAbility() and keys.ability:GetAssociatedPrimaryAbilities() == self:GetAbility():GetName() then
		self:Destroy()
	end
end

function modifier_imba_timbersaw_chakram_thinker:IsHidden() return true end

function modifier_imba_timbersaw_chakram_thinker:IsAura() return true end

function modifier_imba_timbersaw_chakram_thinker:IsAuraActiveOnDeath() return true end

function modifier_imba_timbersaw_chakram_thinker:GetAuraRadius() return self.radius end

function modifier_imba_timbersaw_chakram_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end

function modifier_imba_timbersaw_chakram_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_imba_timbersaw_chakram_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

function modifier_imba_timbersaw_chakram_thinker:GetModifierAura() return "modifier_imba_timbersaw_chakram_debuff" end

-------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_CHAKRAM_DEBUFF --
-------------------------------------------

-- "The slow debuff from passing and from the stationary aura are the same. However, the former is dispellable, the latter is not."
function modifier_imba_timbersaw_chakram_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost.vpcf"
end

function modifier_imba_timbersaw_chakram_debuff:OnCreated()
	if self:GetAbility() then
		self.slow                   = self:GetAbility():GetSpecialValueFor("slow")
		self.slow_health_percentage = self:GetAbility():GetSpecialValueFor("slow_health_percentage")
	else
		self.slow                   = 0
		self.slow_health_percentage = 0
	end

	if not IsServer() then return end
end

function modifier_imba_timbersaw_chakram_debuff:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_imba_timbersaw_chakram_debuff:GetModifierMoveSpeedBonus_Percentage()
	return math.ceil((self:GetParent():GetHealthPercent() - 100) / self.slow_health_percentage) * self.slow
end

-------------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_CHAKRAM_DISARM --
-------------------------------------------

function modifier_imba_timbersaw_chakram_disarm:IsDebuff() return true end

function modifier_imba_timbersaw_chakram_disarm:IsPurgable() return false end

function modifier_imba_timbersaw_chakram_disarm:RemoveOnDeath() return false end

function modifier_imba_timbersaw_chakram_disarm:CheckState()
	-- I don't think this shows on client-side
	if not IsServer() then return end

	return { [MODIFIER_STATE_DISARMED] = true }
end

------------------------------
-- IMBA_TIMBERSAW_CHAKRAM_3 --
------------------------------

function imba_timbersaw_chakram_3:IsInnateAbility() return true end

function imba_timbersaw_chakram_3:IsStealable() return false end

function imba_timbersaw_chakram_3:ProcsMagicStick() return false end

function imba_timbersaw_chakram_3:GetCastRange(location, target)
	return self.BaseClass.GetCastRange(self, location, target) + math.max(self:GetCaster():GetModifierStackCount("modifier_imba_timbersaw_chakram_3", self:GetCaster()) - self:GetSpecialValueFor("trees_to_activate"), 0)
end

function imba_timbersaw_chakram_3:GetIntrinsicModifierName()
	return "modifier_imba_timbersaw_chakram_3"
end

function imba_timbersaw_chakram_3:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function imba_timbersaw_chakram_3:OnSpellStart()
	-- Preventing projectiles getting stuck in one spot due to potential 0 length vector
	if self:GetCursorPosition() == self:GetCaster():GetAbsOrigin() then
		self:GetCaster():SetCursorPosition(self:GetCursorPosition() + self:GetCaster():GetForwardVector())
	end

	if not self.projectiles then
		self.projectiles = {}
	end

	self:GetCaster():EmitSound("Hero_Shredder.Chakram.Cast")

	local ExtraData = {
		-- chakram_particle = chakram_particle,
		cast_pos_x     = self:GetCaster():GetAbsOrigin().x,
		cast_pos_y     = self:GetCaster():GetAbsOrigin().y,
		cast_pos_z     = self:GetCaster():GetAbsOrigin().z,
		bAutoCastState = self:GetAutoCastState()
	}

	local chakram_projectile = ProjectileManager:CreateLinearProjectile({
		Source           = self:GetCaster(),
		Ability          = self,
		vSpawnOrigin     = self:GetCaster():GetAbsOrigin(),
		bDeleteOnHit     = false,
		EffectName       = "particles/econ/items/timbersaw/timbersaw_ti9_gold/timbersaw_ti9_chakram_gold.vpcf",
		fDistance        = self:GetCastRange(self:GetCursorPosition(), self:GetCaster()) + self:GetCaster():GetCastRangeBonus(),
		vVelocity        = (self:GetCursorPosition() - self:GetCaster():GetAbsOrigin()):Normalized() * self:GetSpecialValueFor("speed") * Vector(1, 1, 0),
		fStartRadius     = self:GetSpecialValueFor("radius"),
		fEndRadius       = self:GetSpecialValueFor("radius"),
		iUnitTargetTeam  = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType  = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bHasFrontalCone  = false,
		bReplaceExisting = false,
		fExpireTime      = GameRules:GetGameTime() + 10.0,
		-- "Chakram provides 300 radius flying vision while spinning in place at the target area (but not while traveling)."
		bProvidesVision  = false,
		ExtraData        = ExtraData
	})

	self.projectiles[chakram_projectile] = ExtraData
end

function imba_timbersaw_chakram_3:OnProjectileThinkHandle(projectileHandle)
	if #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), true) >= 1 then
		for _, tree in pairs(GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)) do
			EmitSoundOnLocationWithCaster(tree:GetAbsOrigin(), "Hero_Shredder.Chakram.Tree", self:GetCaster())
		end

		if not self.dendrophobia_modifier or self.dendrophobia_modifier:IsNull() then
			self.dendrophobia_modifier = self:GetCaster():FindModifierByNameAndCaster("modifier_imba_timbersaw_chakram_3", self:GetCaster())
		end

		if self.dendrophobia_modifier then
			self.dendrophobia_modifier:SetStackCount(self.dendrophobia_modifier:GetStackCount() + #GridNav:GetAllTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false))
		end

		GridNav:DestroyTreesAroundPoint(ProjectileManager:GetLinearProjectileLocation(projectileHandle), self:GetSpecialValueFor("radius"), false)
	end
end

-- This is for the launching chakram logic (linear projectile)
function imba_timbersaw_chakram_3:OnProjectileHitHandle(target, location, projectileHandle)
	if target and target ~= self:GetCaster() then
		target:EmitSound("Hero_Shredder.Chakram.Target")

		-- "A passing Chakram first applies the passing damage, then the debuff."
		ApplyDamage({
			victim       = target,
			damage       = self:GetSpecialValueFor("pass_damage"),
			damage_type  = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			attacker     = self:GetCaster(),
			ability      = self
		})

		target:AddNewModifier(self:GetCaster(), self, "modifier_imba_timbersaw_chakram_debuff", { duration = self:GetSpecialValueFor("pass_slow_duration") * (1 - target:GetStatusResistance()) })
	end
end

---------------------------------------
-- MODIFIER_IMBA_TIMBERSAW_CHAKRAM_3 --
---------------------------------------

function modifier_imba_timbersaw_chakram_3:OnStackCountChanged(stackCount)
	if not IsServer() then return end

	if self:GetAbility() and self:GetAbility():IsTrained() and self:GetStackCount() >= self:GetAbility():GetSpecialValueFor("trees_to_activate") and self:GetAbility():IsHidden() then
		self:GetAbility():SetHidden(false)
	end
end

function modifier_imba_timbersaw_chakram_3:DeclareFunctions()
	return { MODIFIER_PROPERTY_TOOLTIP }
end

function modifier_imba_timbersaw_chakram_3:OnTooltip()
	return self:GetAbility():GetSpecialValueFor("trees_to_activate")
end

---------------------
-- TALENT HANDLERS --
---------------------

LinkLuaModifier("modifier_special_bonus_imba_timbersaw_reactive_armor_max_stacks", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_timbersaw_whirling_death_stat_loss_pct", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_special_bonus_imba_timbersaw_timber_chain_range", "components/abilities/heroes/hero_timbersaw", LUA_MODIFIER_MOTION_NONE)

modifier_special_bonus_imba_timbersaw_reactive_armor_max_stacks    = modifier_special_bonus_imba_timbersaw_reactive_armor_max_stacks or class({})
modifier_special_bonus_imba_timbersaw_whirling_death_stat_loss_pct = modifier_special_bonus_imba_timbersaw_whirling_death_stat_loss_pct or class({})
modifier_special_bonus_imba_timbersaw_timber_chain_range           = class({})

function modifier_special_bonus_imba_timbersaw_reactive_armor_max_stacks:IsHidden() return true end

function modifier_special_bonus_imba_timbersaw_reactive_armor_max_stacks:IsPurgable() return false end

function modifier_special_bonus_imba_timbersaw_reactive_armor_max_stacks:RemoveOnDeath() return false end

function modifier_special_bonus_imba_timbersaw_whirling_death_stat_loss_pct:IsHidden() return true end

function modifier_special_bonus_imba_timbersaw_whirling_death_stat_loss_pct:IsPurgable() return false end

function modifier_special_bonus_imba_timbersaw_whirling_death_stat_loss_pct:RemoveOnDeath() return false end

function modifier_special_bonus_imba_timbersaw_timber_chain_range:IsHidden() return true end

function modifier_special_bonus_imba_timbersaw_timber_chain_range:IsPurgable() return false end

function modifier_special_bonus_imba_timbersaw_timber_chain_range:RemoveOnDeath() return false end

function imba_timbersaw_timber_chain:OnOwnerSpawned()
	if not IsServer() then return end

	if self:GetCaster():HasTalent("special_bonus_imba_timbersaw_timber_chain_range") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_timbersaw_timber_chain_range") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetCaster():FindAbilityByName("special_bonus_imba_timbersaw_timber_chain_range"), "modifier_special_bonus_imba_timbersaw_timber_chain_range", {})
	end
end
