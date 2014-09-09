function BaseEnableHaveKids( keys )
	local homestead = keys.caster
	homestead:FindAbilityByName( "base_have_kids" ):SetLevel( 1 );
end

function ColonistBuildBase( keys )
	local builder = keys.caster 
	local building = CreateUnitByName( "npc_dota_building_homebase", keys.target_points[1], false, nil, nil, builder:GetTeamNumber() )
	building.PlayerOwner = builder:GetPlayerOwner()
	building:SetControllableByPlayer( builder:GetOwner():GetPlayerID(), true )
end

function BaseHaveKids( keys )
	local builder = keys.caster 
	local unit = CreateUnitByName( "npc_dota_unit_son", builder:GetAbsOrigin() + RandomVector( 300 ), true, nil, nil, builder:GetTeamNumber() )
	unit.PlayerOwner = builder.PlayerOwner
	unit:SetControllableByPlayer( builder.PlayerOwner:GetPlayerID(), true )
end

function WorkerGatherWood( keys )
	local worker = keys.caster
	local wood = CreateItem( "item_dd_wood", worker.PlayerOwner:GetAssignedHero(), worker.PlayerOwner:GetAssignedHero() )
	local tree = keys.target
	
	if not tree.lumber then
		tree.lumber = 15
	end
	
	-- transfer the wood
	tree.lumber = tree.lumber - 1
	worker:AddItem( wood )
	
	-- cut down tree if it's out of wood
	if tree.lumber == 0 then
		tree:CutDown( worker:GetTeamNumber() )
	end
	
	-- continue gathering or return wood to base
	local stack = worker:GetItemInSlot( 0 )
	if stack:GetCurrentCharges() < 10 then
		worker:CastAbilityOnTarget(tree, worker:FindAbilityByName( "worker_gather_wood" ), worker.PlayerOwner:GetPlayerID())
	else
		local ents = Entities:FindAllByClassname( "npc_dota_creature" )
		for i, ent in ipairs( ents ) do
			if ent.GetUnitName and ent:GetUnitName() == "npc_dota_building_homebase" then
				worker:CastAbilityOnTarget( ent, worker:FindAbilityByName( "worker_return_wood" ), worker.PlayerOwner:GetPlayerID() )
			end
		end
	end
end

function WorkerReturnWood( keys )
	local worker = keys.caster
	local wood = worker:GetItemInSlot( 0 )
	local hero = worker.PlayerOwner:GetAssignedHero()
	if wood then
		hero:ModifyGold( wood:GetCurrentCharges() * wood:GetCost(), true, 1 )
		hero:RemoveItem( wood )
	end
end