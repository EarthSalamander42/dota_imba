-- Copyright (C) 2018  The Dota IMBA Development Team
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
-- http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
-- Author:
--    naowin, 19.08.2018

--------------------------------------------------------------
--			  			Arctic Burn  						--
--------------------------------------------------------------
LinkLuaModifier("modifier_imba_winter_wyvern_arctic_burn", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_arctic_burn_slow", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_arctic_burn_damage", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_arctic_burn_flight", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
imba_winter_wyvern_arctic_burn = class({})
function imba_winter_wyvern_arctic_burn:GetBehavior()
	local caster = self:GetCaster()
	if caster:HasScepter() == true then 
		return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
end

function imba_winter_wyvern_arctic_burn:OnSpellStart()
	if IsServer() then
		local caster 	= self:GetCaster();
		local ability 	= self;
		imba_winter_wyvern_arctic_burn:ToggleOn(caster, ability);
	end
end

function imba_winter_wyvern_arctic_burn:OnToggle()
	if IsServer() then 
		local toggle 	= self:GetToggleState();
		local caster 	= self:GetCaster();
		local ability 	= self;

		if toggle == true then 
			imba_winter_wyvern_arctic_burn:ToggleOn(caster, ability);
		else 
			caster:RemoveModifierByName("modifier_winter_wyvern_arctic_burn_flight");
			caster:RemoveModifierByName("modifier_imba_winter_wyvern_arctic_burn");
		end
	end
end

function imba_winter_wyvern_arctic_burn:ToggleOn(caster, ability)
	local duration = ability:GetSpecialValueFor("duration");
	if caster:HasScepter() == true then 
		duration = -1;
	end

	caster:EmitSound("Hero_Winter_Wyvern.ArcticBurn.Cast");

	caster:AddNewModifier(caster, ability, "modifier_winter_wyvern_arctic_burn_flight", {duration = duration});
	local start_flight_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_ABSORIGIN, caster);
	ParticleManager:SetParticleControl(start_flight_particle, 0, caster:GetAbsOrigin());
	ParticleManager:ReleaseParticleIndex(start_flight_particle);

	local attack_range_bonus = ability:GetSpecialValueFor("attack_range_bonus");
	local arctic_burn_modifier = caster:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_arctic_burn", {duration = duration});
	arctic_burn_modifier:SetStackCount(attack_range_bonus);
end

--------------------------------------------------------------
--  			Arctic Burn (handle modifier) 				--
--------------------------------------------------------------
modifier_imba_winter_wyvern_arctic_burn = class({})
function modifier_imba_winter_wyvern_arctic_burn:IsHidden() return true end
function modifier_imba_winter_wyvern_arctic_burn:DeclareFunctions() 
	decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_arctic_burn:OnAttackLanded(keys)
	if IsServer() then 
		local caster = self:GetCaster();
		if keys.attacker == caster and not keys.target:IsBuilding() then
			local damage_duration = self:GetAbility():GetSpecialValueFor("damage_duration");
			if not keys.target:HasModifier("modifier_imba_winter_wyvern_arctic_burn_damage") or caster:HasScepter() == true then
				local ability = self:GetAbility();
				keys.target:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_arctic_burn_damage", {duration = damage_duration});

				local slow = ability:GetSpecialValueFor("move_slow");
				local slow_modifier = keys.target:AddNewModifier(caster, self:GetAbility(), "modifier_imba_winter_wyvern_arctic_burn_slow", {duration = damage_duration});
				slow_modifier:SetStackCount(slow * -1)
				
				EmitSoundOn("Hero_Winter_Wyvern.ArcticBurn.projectileImpact", keys.target);


				if RandomInt(1,100) > 80 then 
					caster:EmitSound("winter_wyvern_winwyv_articburn_0"..RandomInt(1, 4));
				end
			end
		end
	end
end

function modifier_imba_winter_wyvern_arctic_burn:GetModifierAttackRangeBonus()
	return self:GetStackCount();
end

function modifier_imba_winter_wyvern_arctic_burn:GetModifierProjectileSpeedBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_projectile_speed")
end

function modifier_imba_winter_wyvern_arctic_burn:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed")
end

function modifier_imba_winter_wyvern_arctic_burn:GetModifierAttackPointConstant()
	return self:GetAbility():GetSpecialValueFor("attack_point")
end

function modifier_imba_winter_wyvern_arctic_burn:GetModifierBaseAttackTimeConstant()
	return self:GetAbility():GetSpecialValueFor("bat_constant")
end

--------------------------------------------------------------
--  			Arctic Burn (Slow modifier) 				--
--------------------------------------------------------------
modifier_imba_winter_wyvern_arctic_burn_slow = class({})
function modifier_imba_winter_wyvern_arctic_burn_slow:IsHidden() return true end
function modifier_imba_winter_wyvern_arctic_burn_slow:DeclareFunctions() 
	decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_arctic_burn_slow:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetStackCount();
end

--------------------------------------------------------------
--  			Arctic Burn (Damage modifier) 				--
--------------------------------------------------------------
modifier_imba_winter_wyvern_arctic_burn_damage = class({})
function modifier_imba_winter_wyvern_arctic_burn_damage:IsHidden() return false end
function modifier_imba_winter_wyvern_arctic_burn_damage:OnCreated() 
	if IsServer() then 
		self.ability 				= self:GetAbility();
		self.health_dmg_conversion 	= self.ability:GetSpecialValueFor("percent_damage") / 100;
		self.scepter_dmg_pct 		= self.ability:GetSpecialValueFor("scepter_dmg_pct") / 100;
		self.slow_hit_particle 		= ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent());
		ParticleManager:SetParticleControl(self.slow_hit_particle, 0, self:GetParent():GetAbsOrigin());

		self:StartIntervalThink(1.0);
	end
end

function modifier_imba_winter_wyvern_arctic_burn_damage:OnIntervalThink()
	local parent 			= self:GetParent();
	local caster 			= self:GetCaster();
	local current_health 	= parent:GetHealth();
	local damage 			= current_health * self.health_dmg_conversion;
	
	if caster:HasScepter() == true then
		local max_health = parent:GetMaxHealth();
		damage = damage + (max_health * self.scepter_dmg_pct);
	end

	local damage_type = DAMAGE_TYPE_MAGICAL;
	if caster:HasTalent("special_bonus_imba_winter_wyvern_5") then 
		damage_type = DAMAGE_TYPE_PURE;
	end

	local damage_table 			= {};
	damage_table.attacker 		= caster;
	damage_table.ability 		= self.ability;
	damage_table.damage_type 	= damage_type;
	damage_table.damage	 		= damage;
	damage_table.victim  		= parent;

	ApplyDamage(damage_table);
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, parent, damage, nil);
end

function modifier_imba_winter_wyvern_arctic_burn_damage:OnRemoved() 
	if IsServer() then 
		ParticleManager:DestroyParticle(self.slow_hit_particle, false);
	end
end

------------------------------------------------------------------
--			  			Splinter Blast  						--
------------------------------------------------------------------
LinkLuaModifier("modifier_imba_winter_wyvern_splinter_blast_slow", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_splinter_blast_splinter_charge", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
imba_winter_wyvern_splinter_blast = class({});
function imba_winter_wyvern_splinter_blast:OnSpellStart() 
	if IsServer() then
		local caster 						= self:GetCaster();
		local target 						= self:GetCursorTarget();
		local secondary_projectile_speed 	= self:GetSpecialValueFor("secondary_projectile_speed");
		local split_radius 					= self:GetSpecialValueFor("split_radius");
		local slow_duration 				= self:GetSpecialValueFor("duration");
		local slow 							= self:GetSpecialValueFor("bonus_movespeed");
		local attack_slow 					= self:GetSpecialValueFor("attack_slow");
		local hero_cdr 						= self:GetSpecialValueFor("hero_cdr");
		local cdr_units 					= self:GetSpecialValueFor("cdr_units");
		local splinter_threshold			= self:GetSpecialValueFor("threshold");
		local splinter_dmg_efficiency		= self:GetSpecialValueFor("splinter_dmg_efficiency");
		local splinter_aoe_efficiency		= self:GetSpecialValueFor("splinter_aoe_efficiency");
		local damage 						= self:GetAbilityDamage();
		local speed							= self:GetSpecialValueFor("projectile_speed")

		caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Cast");

		imba_winter_wyvern_splinter_blast:CreateTrackingProjectile(
		{
			target 						= target,
			caster 						= caster,
			ability 					= self,
			iMoveSpeed 					= speed,
			iSourceAttachment 			= self:GetCaster():ScriptLookupAttachment("attach_attack1"),
			EffectName 					= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
			secondary_projectile_speed 	= secondary_projectile_speed,
			split_radius 				= split_radius,
			slow_duration 				= slow_duration,
			slow						= slow,
			attack_slow 				= attack_slow,
			hero_cdr 					= hero_cdr,
			cdr_units 					= cdr_units,
			splinter_threshold 			= splinter_threshold,
			splinter_dmg_efficiency 	= splinter_dmg_efficiency,
			splinter_aoe_efficiency 	= splinter_aoe_efficiency,
			damage 						= damage,
			splinter_proc 				= 0
		});	
	end
end

-- Adding comments to remember this in the future
function imba_winter_wyvern_splinter_blast:CreateTrackingProjectile(keys)
    local target = keys.target;
    local caster = keys.caster;
    local speed = keys.iMoveSpeed;
 
    -- Set creation time in the parameters
    keys.creation_time = GameRules:GetGameTime();
 
    -- Fetch initial projectile location
    local projectile = caster:GetAttachmentOrigin(keys.iSourceAttachment);
 
    -- Make the particle
    local particle = ParticleManager:CreateParticle(keys.EffectName, PATTACH_POINT, caster);

    caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");

    local arctic_flight_offset = Vector(0,0,0);
    if caster:HasModifier("modifier_winter_wyvern_arctic_burn_flight") then 
    	arctic_flight_offset = Vector(0,0, 150);
    end
    -- Source CP
    ParticleManager:SetParticleControl(particle, 0, caster:GetAttachmentOrigin(keys.iSourceAttachment) + arctic_flight_offset);
    -- TargetCP
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true);
    -- Speed CP
    ParticleManager:SetParticleControl(particle, 2, Vector(speed, 0, 0));
 
    Timers:CreateTimer(function()
        -- Get the target location
        local target_location = target:GetAbsOrigin();
 
        -- Move the projectile towards the target
        projectile = projectile + (target_location - projectile):Normalized() * speed * FrameTime();
 
        -- Check the distance to the target
        if (target_location - projectile):Length2D() < speed * FrameTime() then
            -- Target has reached destination!
            imba_winter_wyvern_splinter_blast:OnTrackingProjectileHit(keys);
            -- Stop projectile sound
            caster:StopSound("Hero_Winter_Wyvern.SplinterBlast.Projectile");
            -- Destroy particle
            ParticleManager:DestroyParticle(particle, false);
            -- Release particle index
            ParticleManager:ReleaseParticleIndex(particle);
 
            -- Stop the timer
            return nil
        else
        	speed = speed + 25;
			ParticleManager:SetParticleControl(particle, 2, Vector(speed, 0, 0));

            -- Reschedule for next frame
            return 0
        end
    end)
end

function imba_winter_wyvern_splinter_blast:OnTrackingProjectileHit(keys)
	-- Stop if target has linkens
	if keys.target:TriggerSpellAbsorb(keys.ability) then return end

	local nearby_enemy_units = FindUnitsInRadius(
		keys.caster:GetTeam(),
		keys.target:GetAbsOrigin(), 
		nil, 
		keys.split_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_ANY_ORDER, 
		false
	);

	keys.caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Target");

	for _,enemy in pairs(nearby_enemy_units) do 
		if enemy ~= keys.target and enemy:IsAlive() then
			local extra_data = {
				damage 						= keys.damage, 
				slow_duration 				= keys.slow_duration, 
				slow 						= keys.slow, 
				attack_slow 				= keys.attack_slow, 
				hero_cdr 					= keys.hero_cdr, 
				cdr_units 					= keys.cdr_units, 
				split_radius 				= keys.split_radius, 
				splinter_threshold 			= keys.splinter_threshold, 
				secondary_projectile_speed 	= keys.secondary_projectile_speed,
				splinter_dmg_efficiency 	= keys.splinter_dmg_efficiency,
				splinter_aoe_efficiency 	= keys.splinter_aoe_efficiency,
				splinter_proc 			   	= keys.splinter_proc
			}

			local projectile =
			{
				Target 				= enemy,
				Source 				= keys.target,
				Ability 			= keys.ability,
				-- TODO: Need to fix the spell visual so the 2nd volley looks smaller and with a diffrent color then the main spell... // nao
				EffectName 			= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast.vpcf",
				iMoveSpeed			= keys.secondary_projectile_speed,
				vSourceLoc 			= keys.target:GetAbsOrigin(),
				bDrawsOnMinimap 	= false,
				bDodgeable 			= false,
				bIsAttack 			= false,
				bVisibleToEnemies 	= true,
				bReplaceExisting 	= false,
				flExpireTime 		= GameRules:GetGameTime() + 10,
				bProvidesVision 	= true,
				iVisionRadius 		= 400,
				iVisionTeamNumber 	= keys.caster:GetTeamNumber(),
				ExtraData = extra_data
			}

			ProjectileManager:CreateTrackingProjectile(projectile);
		end
	end
end

function imba_winter_wyvern_splinter_blast:OnProjectileHit_ExtraData(target, location, ExtraData)
	if target:IsAlive() then 
		local caster = self:GetCaster();
		-- splinter_proc == 0 means this is the first time hero got it. time to triggers a second volley!
		if ExtraData.splinter_proc == 0 then 
			local splinter_proj = {
				caster 						= caster,
				target 						= target,
				ability 					= self,
				damage 						= ExtraData.damage  * (ExtraData.splinter_dmg_efficiency / 100), 
				slow_duration 				= ExtraData.slow_duration, 
				slow 						= ExtraData.slow, 
				attack_slow 				= ExtraData.attack_slow, 
				hero_cdr 					= ExtraData.hero_cdr, 
				cdr_units 					= ExtraData.cdr_units, 
				split_radius 				= ExtraData.split_radius * (ExtraData.splinter_aoe_efficiency / 100), 
				splinter_threshold 			= ExtraData.splinter_threshold, 
				secondary_projectile_speed 	= ExtraData.secondary_projectile_speed,
				splinter_dmg_efficiency  	= ExtraData.splinter_dmg_efficiency,
				splinter_aoe_efficiency 	= ExtraData.splinter_aoe_efficiency,
				splinter_proc 			   	= ExtraData.splinter_proc + 1
			}
			
			imba_winter_wyvern_splinter_blast:OnTrackingProjectileHit(splinter_proj);
		end

		target:AddNewModifier(caster, self, "modifier_imba_winter_wyvern_splinter_blast_slow", {duration = ExtraData.slow_duration, slow = ExtraData.slow, attack_slow = ExtraData.attack_slow});
		
		if	caster:HasTalent("special_bonus_unique_winter_wyvern_4") then
			local stun_duration = caster:FindTalentValue("special_bonus_unique_winter_wyvern_4", "value");
			target:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration});
		end
		
		caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Splinter");

		local ability_winters_curse = caster:FindAbilityByName("imba_winter_wyvern_winters_curse");
		if ability_winters_curse and not ability_winters_curse:IsCooldownReady() then
			local cdr
			if target:IsHero() and not target:IsIllusion() then
				cdr = ExtraData.cdr_hero;
			else
				cdr = ExtraData.cdr_units;
			end
			local current_cooldown = ability_winters_curse:GetCooldownTimeRemaining();
			ability_winters_curse:EndCooldown();
			ability_winters_curse:StartCooldown(current_cooldown - cdr);
		end

		local damage_table 			= {};
		damage_table.attacker 		= caster;
		damage_table.ability 		= self;
		damage_table.damage_type 	= self:GetAbilityDamageType();
		damage_table.damage	 		= ExtraData.damage;
		damage_table.victim  		= target;
		ApplyDamage(damage_table)
	end
end

--------------------------------------------------------------
--  			Splinter Blast (Slow modifier) 				--
--------------------------------------------------------------
modifier_imba_winter_wyvern_splinter_blast_slow = class({})
function modifier_imba_winter_wyvern_splinter_blast_slow:IsHidden() return false end
function modifier_imba_winter_wyvern_splinter_blast_slow:IsDebuff() return true end
function modifier_imba_winter_wyvern_splinter_blast_slow:DeclareFunctions() 
	decFuncs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_splinter_blast_slow:OnCreated(keys)
	if IsServer() then 
		self.slow 				= keys.slow;
		self.attack_slow 		= keys.attack_slow;
		self.slow_hit_particle 	= ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_splinter_blast_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent());
		ParticleManager:SetParticleControl(self.slow_hit_particle, 0, self:GetParent():GetAbsOrigin());
	end
end

function modifier_imba_winter_wyvern_splinter_blast_slow:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.slow_hit_particle, false);
		ParticleManager:ReleaseParticleIndex(self.slow_hit_particle);
	end
end

function modifier_imba_winter_wyvern_splinter_blast_slow:GetModifierMoveSpeedBonus_Percentage()
	--return self.slow;
	return self:GetAbility():GetSpecialValueFor("bonus_movespeed");
end

function modifier_imba_winter_wyvern_splinter_blast_slow:GetModifierAttackSpeedBonus_Constant()
	--return self.attack_slow;
	return self:GetAbility():GetSpecialValueFor("attack_slow");
end

------------------------------------------------------------------
--			  			Cold Embrace	  						--
------------------------------------------------------------------
LinkLuaModifier("modifier_imba_winter_wyvern_cold_embrace", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_cold_embrace_freeze", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_imba_winter_wyvern_cold_embrace_resistance", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
imba_winter_wyvern_cold_embrace = class({})

function imba_winter_wyvern_cold_embrace:GetCooldown(nLevel)
	return self.BaseClass.GetCooldown( self, nLevel ) - self:GetCaster():FindTalentValue("special_bonus_imba_winter_wyvern_6", "cooldown_reduction")
end

function imba_winter_wyvern_cold_embrace:OnSpellStart()
	if IsServer() then 
		local caster 					= self:GetCaster();
		local target 					= self:GetCursorTarget();
		local ability 					= self;
		local duration 					= self:GetSpecialValueFor("duration");
		local damage_treshold_pct_hp 	= self:GetSpecialValueFor("damage_treshold_pct_hp");
		local freeze_duration 			= self:GetSpecialValueFor("freeze_duration");

		if target ~= nil then 		
			caster:EmitSound("Hero_Winter_Wyvern.ColdEmbrace.Cast");

			if RandomInt(1,100) > 80 then 
				caster:EmitSound("winter_wyvern_winwyv_coldembrace_0"..RandomInt(1, 5));
			end

			if caster:HasTalent("special_bonus_imba_winter_wyvern_4") then 
				local magic_resistance = caster:FindTalentValue("special_bonus_imba_winter_wyvern_4", "magic_resitance");
				local cold_embrace_modifier = caster:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_cold_embrace_resistance", {duration = duration});
				cold_embrace_modifier:SetStackCount(magic_resistance);
			end

			-- Handled properly in the GetCooldown function block
			-- if caster:HasTalent("special_bonus_imba_winter_wyvern_6") then 
				-- local cooldown_reduction = caster:FindTalentValue("special_bonus_imba_winter_wyvern_6", "cooldown_reduction");
				-- local cooldown_remaining = ability:GetCooldownTimeRemaining();
				-- ability:EndCooldown();
				-- ability:StartCooldown(math.max(cooldown_remaining - cooldown_reduction, 0));
			-- end

			local cold_embrace_start_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_start.vpcf", PATTACH_POINT, caster);
			ParticleManager:SetParticleControl(cold_embrace_start_particle, 0, caster:GetAbsOrigin());
			ParticleManager:SetParticleControl(cold_embrace_start_particle, 1, caster:GetAbsOrigin());
			ParticleManager:ReleaseParticleIndex(cold_embrace_start_particle);

			target:AddNewModifier(caster, ability, "modifier_winter_wyvern_cold_embrace", {duration = duration});
			target:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_cold_embrace", {duration = duration, damage_treshold_pct_hp = damage_treshold_pct_hp, freeze_duration = freeze_duration});
		end
	end
end



---------------------------------------------------------------------------------------------------------------------
--	Cold Embrace -- Assult handler
---------------------------------------------------------------------------------------------------------------------
modifier_imba_winter_wyvern_cold_embrace = class({})
function modifier_imba_winter_wyvern_cold_embrace:IsHidden() return true end
function modifier_imba_winter_wyvern_cold_embrace:IsPurgable() return false end
function modifier_imba_winter_wyvern_cold_embrace:IsDebuff() return false end
function modifier_imba_winter_wyvern_cold_embrace:DeclareFunctions() 
	decFuncs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_cold_embrace:OnAttackLanded(keys) 
	if IsServer() then 
		local parent = self:GetParent();
		if keys.target == parent then
			self.damage_taken = self.damage_taken + keys.damage;
			
			if self.damage_taken >= self.damage_treshold then
				-- Eh...this seems super bootleg. If you want to do this properly use the IgnoreTenacity() function. Removing for now though
				-- if parent:HasModifier("modifier_frantic") then
					-- self.freeze_duration = self.freeze_duration * 2;
				-- end

				-- Removing weird elapsed time constraint for now
				--if self:GetElapsedTime() > (self:GetDuration() * 0.75) and self.triggered == false then 
					--self.triggered = true;
					
					if not keys.attacker:IsMagicImmune() then
						keys.attacker:AddNewModifier(parent, nil, "modifier_imba_winter_wyvern_cold_embrace_freeze", {duration = self.freeze_duration});
					end
					
					-- Heal to max
					--parent:Heal(parent:GetMaxHealth(), parent);
					
					parent:Heal(self.damage_treshold, parent);
					
					-- Escape particle
					local curse_blast = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_blast.vpcf", PATTACH_ABSORIGIN, parent);
					ParticleManager:SetParticleControl(curse_blast, 2, Vector(1,1,1000));
					ParticleManager:ReleaseParticleIndex(curse_blast);
					
					if self:GetCaster():HasAbility("imba_winter_wyvern_splinter_blast") then
						local splinter_blast = self:GetCaster():FindAbilityByName("imba_winter_wyvern_splinter_blast")
					
						if splinter_blast:IsTrained() then
							
							imba_winter_wyvern_splinter_blast:CreateTrackingProjectile(
								{
									target 						= self:GetCaster(),
									caster 						= self:GetCaster(),
									ability 					= splinter_blast,
									iMoveSpeed 					= splinter_blast:GetSpecialValueFor("projectile_speed"),
									iSourceAttachment 			= self:GetCaster():ScriptLookupAttachment("attach_attack1"),
									EffectName 					= "particles/units/heroes/hero_winter_wyvern/wyvern_splinter.vpcf",
									secondary_projectile_speed 	= splinter_blast:GetSpecialValueFor("secondary_projectile_speed"),
									split_radius 				= splinter_blast:GetSpecialValueFor("split_radius"),
									slow_duration 				= splinter_blast:GetSpecialValueFor("duration"),
									slow						= splinter_blast:GetSpecialValueFor("bonus_movespeed"),
									attack_slow 				= splinter_blast:GetSpecialValueFor("attack_slow"),
									hero_cdr 					= splinter_blast:GetSpecialValueFor("hero_cdr"),
									cdr_units 					= splinter_blast:GetSpecialValueFor("cdr_units"),
									splinter_threshold 			= splinter_blast:GetSpecialValueFor("threshold"),
									splinter_dmg_efficiency 	= splinter_blast:GetSpecialValueFor("splinter_dmg_efficiency"),
									splinter_aoe_efficiency 	= splinter_blast:GetSpecialValueFor("splinter_aoe_efficiency"),
									damage 						= splinter_blast:GetAbilityDamage() + self.damage_taken,
									splinter_proc 				= 1
								});
						end
					end
					
					-- Reset damage taken
					self.damage_taken = 0
					
					-- Gonna make it not remove for now
					
					-- Remove Cold Embrace, could not get healing to work without delay.
					-- Timers:CreateTimer(0.03, function()
						-- parent:RemoveModifierByName("modifier_winter_wyvern_cold_embrace");
						-- parent:RemoveModifierByName("modifier_imba_winter_wyvern_cold_embrace");
					-- end)
				--end
			end
		end
	end
end

function modifier_imba_winter_wyvern_cold_embrace:OnCreated(keys)
	if IsServer() then 
		self.triggered 			= false;
		self.damage_taken 		= 0;
		self.freeze_duration 	= keys.freeze_duration;
		-- Shatter Cold Embrace after 75% of the duration if this dmg treshold is reached
		self.damage_treshold 	= (self:GetCaster():GetMaxHealth() / 100) * keys.damage_treshold_pct_hp;
	end
end

function modifier_imba_winter_wyvern_cold_embrace:OnRefreshed(keys)
	if IsServer() then 
		self.triggered 			= false;
		self.damage_taken 		= 0;
		self.freeze_duration 	= keys.freeze_duration;
		-- Shatter Cold Embrace after 75% of the duration if this dmg treshold is reached
		self.damage_treshold 	= (self:GetCaster():GetMaxHealth() / 100) * keys.damage_treshold_pct_hp;
	end
end

---------------------------------------------------------------------------------------------------------------------
--	Cold Embrace -- Resistance
---------------------------------------------------------------------------------------------------------------------
modifier_imba_winter_wyvern_cold_embrace_resistance = class({})
function modifier_imba_winter_wyvern_cold_embrace_resistance:IsHidden() return true end
function modifier_imba_winter_wyvern_cold_embrace_resistance:DeclareFunctions() 
	decFuncs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return decFuncs
end

function modifier_imba_winter_wyvern_cold_embrace_resistance:GetModifierMagicalResistanceBonus()
	return self:GetStackCount();
end

---------------------------------------------------------------------------------------------------------------------
--	Cold Embrace -- Freeze
---------------------------------------------------------------------------------------------------------------------
modifier_imba_winter_wyvern_cold_embrace_freeze = class({})
function modifier_imba_winter_wyvern_cold_embrace_freeze:IsDebuff() return true end
function modifier_imba_winter_wyvern_cold_embrace_freeze:IsPurgable() return true end
function modifier_imba_winter_wyvern_cold_embrace_freeze:IsHidden() return false end
function modifier_imba_winter_wyvern_cold_embrace_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_imba_winter_wyvern_cold_embrace_freeze:OnCreated()
	EmitSoundOn("Hero_Ancient_Apparition.ColdFeetCast", self:GetParent())
end

function modifier_imba_winter_wyvern_cold_embrace_freeze:GetEffectName()
	return "particles/units/heroes/hero_ancient_apparition/ancient_apparition_cold_feet_frozen.vpcf"
end

function modifier_imba_winter_wyvern_cold_embrace_freeze:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

------------------------------------------------------------------
--						Winters Curse 							--
------------------------------------------------------------------
LinkLuaModifier("modifier_imba_winter_wyvern_winters_curse", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
imba_winter_wyvern_winters_curse = class({})
function imba_winter_wyvern_winters_curse:OnSpellStart()
	if IsServer() then 
		local caster 	= self:GetCaster();
		local target 	= self:GetCursorTarget();
		local ability 	= self;
		local duration  = self:GetSpecialValueFor("duration");

		if caster:HasTalent("special_bonus_imba_winter_wyvern_7") then 
			local bonus_duration = caster:FindTalentValue("special_bonus_imba_winter_wyvern_7", "duration");
			duration = duration + bonus_duration
			target:AddNewModifier(caster, ability, "modifier_imba_winter_wyvern_winters_curse", {duration = duration});
		end

		caster:EmitSound("Hero_Winter_Wyvern.WintersCurse.Cast");

		-- Stop if target has linkens
		if target:TriggerSpellAbsorb(ability) then return end
		
		target:EmitSound("Hero_Winter_Wyvern.WintersCurse.Target");
		if RandomInt(1,100) > 80 then 
			local random_sound = RandomInt(1, 14);
			if random_sound < 10 then 
				caster:EmitSound("winter_wyvern_winwyv_winterscurse_0"..random_sound);
			else
				caster:EmitSound("winter_wyvern_winwyv_winterscurse_"..random_sound);
			end
		end

		caster:AddNewModifier(caster, ability, "winter_wyvern_winters_curse_kill_credit", {});
		target:AddNewModifier(caster, ability, "modifier_winter_wyvern_winters_curse_aura", {duration = duration});
	end
end

function imba_winter_wyvern_winters_curse:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end 



------------------------------------------------------------------
--			Winters Curse (dissable passives modifier) 			--
------------------------------------------------------------------
modifier_imba_winter_wyvern_winters_curse = class({})
function modifier_imba_winter_wyvern_winters_curse:IsHidden() return true end
function modifier_imba_winter_wyvern_winters_curse:IsDebuff() return false end
function modifier_imba_winter_wyvern_winters_curse:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}
	return state
end

------------------------------------------------------------------------------
--		Winter Wyvern Talent 4 (Magic Resistance during cold Embrace) 		--
------------------------------------------------------------------------------
LinkLuaModifier("modifier_special_bonus_imba_winter_wyvern_4", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_winter_wyvern_4 = class({})
function modifier_special_bonus_imba_winter_wyvern_4:IsHidden() return true end
function modifier_special_bonus_imba_winter_wyvern_4:RemoveOnDeath() return false end
function modifier_special_bonus_imba_winter_wyvern_4:IsPurgable() return false end



------------------------------------------------------------------------------
--				Winter Wyvern Talent 5 (Pure Arctic damage) 				--
------------------------------------------------------------------------------
LinkLuaModifier("modifier_special_bonus_imba_winter_wyvern_5", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_winter_wyvern_5 = class({})
function modifier_special_bonus_imba_winter_wyvern_5:IsHidden() return true end
function modifier_special_bonus_imba_winter_wyvern_5:RemoveOnDeath() return false end
function modifier_special_bonus_imba_winter_wyvern_5:IsPurgable() return false end


------------------------------------------------------------------------------
--			Winter Wyvern Talent 6 (Cold Embrace Cooldown Reduction) 		--
------------------------------------------------------------------------------
LinkLuaModifier("modifier_special_bonus_imba_winter_wyvern_6", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_winter_wyvern_6 = class({})
function modifier_special_bonus_imba_winter_wyvern_6:IsHidden() return true end
function modifier_special_bonus_imba_winter_wyvern_6:RemoveOnDeath() return false end
function modifier_special_bonus_imba_winter_wyvern_6:IsPurgable() return false end

function imba_winter_wyvern_cold_embrace:OnOwnerSpawned()
	if self:GetCaster():HasTalent("special_bonus_imba_winter_wyvern_6") and not self:GetCaster():HasModifier("modifier_special_bonus_imba_winter_wyvern_6") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_imba_winter_wyvern_6", {})
	end
end

----------------------------------------------------------------------
--			Winter Wyvern Talent 8 (IMBA Winter's Curse) 			--
----------------------------------------------------------------------
LinkLuaModifier("modifier_special_bonus_imba_winter_wyvern_7", "components/abilities/heroes/hero_winter_wyvern.lua", LUA_MODIFIER_MOTION_NONE)
modifier_special_bonus_imba_winter_wyvern_7 = class({})
function modifier_special_bonus_imba_winter_wyvern_7:IsHidden() return true end
function modifier_special_bonus_imba_winter_wyvern_7:RemoveOnDeath() return false end
function modifier_special_bonus_imba_winter_wyvern_7:IsPurgable() return false end