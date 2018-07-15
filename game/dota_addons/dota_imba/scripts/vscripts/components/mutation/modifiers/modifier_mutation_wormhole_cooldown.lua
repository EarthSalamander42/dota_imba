modifier_mutation_wormhole_cooldown = class({})

function modifier_mutation_wormhole_cooldown:IsHidden() return false end
function modifier_mutation_wormhole_cooldown:IsDebuff() return true end
function modifier_mutation_wormhole_cooldown:IsPurgable() return false end

function modifier_mutation_wormhole_cooldown:GetTexture() return "wisp_relocate" end
