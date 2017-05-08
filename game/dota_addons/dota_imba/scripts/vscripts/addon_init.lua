if IsClient() then	-- Load clientside utility lib
	require("/libraries/client_util")

	--Load ability KVs
	AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    IMBA_GENERIC_TALENT_LIST = LoadKeyValues("scripts/npc/KV/imba_generic_talent_list.kv")
end