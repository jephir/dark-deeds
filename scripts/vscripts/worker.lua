local initialized = false

thisEntity:SetContextThink( "WorkerThink", function ()
	if not initialized then
		thisEntity:FindAbilityByName( "worker_gather_wood" ):ToggleAutoCast()
		initialized = true
	end
	
	if thisEntity:IsIdle() and thisEntity:FindAbilityByName( "worker_gather_wood" ):GetAutoCastState() then
		thisEntity:CastAbilityOnTarget( GetClosestTree(), thisEntity:FindAbilityByName( "worker_gather_wood" ), thisEntity.PlayerOwner:GetPlayerID() )
	end

	return 0.1
end, 0.1 )

function GetClosestTree()
	local trees = Entities:FindAllByClassnameWithin( "ent_dota_tree", thisEntity:GetOrigin(), 3000 )
	table.sort( trees, IsCloser )
	for i, tree in ipairs( trees ) do
		if tree:IsStanding() then
			return tree
		end
	end
end

function IsCloser( a, b )
	local aDistance = thisEntity:GetOrigin() - a:GetOrigin()
	local bDistance = thisEntity:GetOrigin() - b:GetOrigin()
	return aDistance:Length() < bDistance:Length()
end