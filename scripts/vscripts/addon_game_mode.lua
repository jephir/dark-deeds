if CDarkDeedsGameMode == nil then
	CDarkDeedsGameMode = class({})
end

function Precache( context )
	PrecacheUnitByNameSync( "npc_dota_hero_sven", context )
	PrecacheUnitByNameSync( "npc_dota_building_homebase", context )
	PrecacheUnitByNameSync( "npc_dota_unit_crystal_maiden", context )
	PrecacheUnitByNameSync( "npc_dota_hero_kunkka", context )
end

function Activate()
	GameRules.DarkDeeds = CDarkDeedsGameMode()
	GameRules.DarkDeeds:InitGameMode()
end

function CDarkDeedsGameMode:InitGameMode()
	print( "Dark Deeds is loaded." )
		
	GameRules:SetHeroSelectionTime( 0.0 )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	
	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( CDarkDeedsGameMode, "onPlayerLoaded" ), self )
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( CDarkDeedsGameMode, "OnNPCSpawn" ), self )
		
	SendToServerConsole( "jointeam good" )
end

function CDarkDeedsGameMode:OnThink()

	-- Reconnect heroes
	for _, hero in pairs( Entities:FindAllByClassname( "npc_dota_hero_sven" )) do
		if hero:GetPlayerOwnerID() == -1 then
			local id = hero:GetPlayerOwner():GetPlayerID()
			if id ~= -1 then
				print( "Reconnecting hero for player " .. id )
				hero:SetControllableByPlayer( id, true )
				hero:SetPlayerID( id )
			end
		end
	end
		
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	
	return 1
end

function CDarkDeedsGameMode:OnNPCSpawn( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	
	if spawnedUnit:IsRealHero() then
		spawnedUnit:FindAbilityByName( "colonist_build_base" ):SetLevel(1)
		spawnedUnit:HeroLevelUp( false )
		spawnedUnit:SetAbilityPoints( 0 )
	end
end

function CDarkDeedsGameMode:onPlayerLoaded( keys )
	local player = PlayerInstanceFromIndex( keys.index + 1 )
	print( "Creating hero." )
	local hero = CreateHeroForPlayer( "npc_dota_hero_sven", player )

	-- if GameMode == nil then
		-- GameMode = GameRules:GetGameModeEntity()
		-- GameMode:SetFogOfWarDisabled( true )
	-- end

	-- local ply = EntIndexToHScript( keys.index + 1 )
	-- local playerID = ply:GetPlayerID()

	-- if PlayerResource:IsBroadcaster( playerID ) then
		-- return
	-- end

	-- if playerID == -1 then
		-- ply:SetTeam( DOTA_TEAM_GOODGUYS )
		-- ply = CreateHeroForPlayer( "npc_dota_hero_abaddon", ply )
	-- end
end