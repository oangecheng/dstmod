local action_string = GLOBAL.STRINGS.ACTIONS.EAT 

local WATAME_EAT_GRASS = AddAction("WATAME_EAT_GRASS", action_string, function(act)
    local obj = act.target or act.invobject
    if obj then
		if obj.components.stackable then
            act.doer.components.hunger:DoDelta(3)
			local food = obj.components.stackable:Get()
            food:Remove()
		end
        return true
    end
end)

AddComponentAction("INVENTORY", "watame_edible", function(inst, doer, actions, right)
    -- local trap =  doer.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
	if doer~=nil and doer.prefab=="watame" and inst~=nil then
		WATAME_EAT_GRASS.priority = 1
		table.insert(actions, WATAME_EAT_GRASS)
	end
end)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(WATAME_EAT_GRASS, "quickeat")) 
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(WATAME_EAT_GRASS, "quickeat"))

AddPrefabPostInit("cutgrass",function(inst)
    inst:AddComponent("watame_edible") -- we need this component, although it does nothing, to be able to do AddComponentAction
end)