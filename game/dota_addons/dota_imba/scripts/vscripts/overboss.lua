function ThrowCoin( args )
--	log.debug( "ThrowCoin" )
	local coinAttach = args.caster:ScriptLookupAttachment( "coin_toss_point" )
	local coinSpawn = Vector( 0, 0, 0 )
	if coinAttach ~= -1 then
		coinSpawn = args.caster:GetAttachmentOrigin( coinAttach )
	end
--	log.debug( coinSpawn )
	SpawnGoldEntity( coinSpawn )
end
