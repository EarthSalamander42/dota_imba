modifier_mutation_rupture = modifier_mutation_rupture or class({})

function modifier_mutation_rupture:IsDebuff() return true end
function modifier_mutation_rupture:IsPurgable() return false end

function modifier_mutation_rupture:GetTexture()
	return "bloodseeker_rupture"
end

if IsServer() then
	function modifier_mutation_rupture:OnCreated()
		self.caster = self:GetCaster()

		self.movedamage = 50 * 0.01
		self.attackdamage = 50
		self.castdamage = 100
		self.damagecap = 1300
		self.prevLoc = self:GetParent():GetAbsOrigin()
		self:StartIntervalThink(0.25)
		EmitSoundOn("hero_bloodseeker.rupture", self:GetParent())
	end

	function modifier_mutation_rupture:OnIntervalThink()
		local game_time = math.min(GameRules:GetDOTATime(false, false) / 60, 30)
		self.castdamage = 50 + (game_time * 10)
		self.movedamage = (50 + (game_time * 10)) * 0.01
		self.attackdamage = 50 + (game_time * 10)

		if CalculateDistance(self.prevLoc, self:GetParent()) < self.damagecap then
			local move_damage = CalculateDistance(self.prevLoc, self:GetParent()) * self.movedamage
			if move_damage > 0 then
				ApplyDamage({victim = self:GetParent(), attacker = self.caster, damage = move_damage, damage_type = DAMAGE_TYPE_PURE})
			end
		end

		self.prevLoc = self:GetParent():GetAbsOrigin()
	end

	function modifier_mutation_rupture:DeclareFunctions()
		local funcs = {
			MODIFIER_EVENT_ON_ABILITY_START,
			MODIFIER_EVENT_ON_ATTACK_START,
		}

		return funcs
	end

	function modifier_mutation_rupture:OnAbilityStart(params)
		if params.unit == self:GetParent() then
			ApplyDamage({victim = self:GetParent(), attacker = self.caster, damage = self.castdamage, damage_type = DAMAGE_TYPE_PURE})
		end
	end

	function modifier_mutation_rupture:OnAttackStart(params)
		if params.attacker == self:GetParent() then
			ApplyDamage({victim = self:GetParent(), attacker = self.caster, damage = self.castdamage, damage_type = DAMAGE_TYPE_PURE})
		end
	end

	function modifier_mutation_rupture:OnDestroy()
		--Stop Meme Sounds
		StopSoundEvent("Imba.BloodseekerBadDay", self.parent)
	end
end

function modifier_mutation_rupture:GetEffectName()
	return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end