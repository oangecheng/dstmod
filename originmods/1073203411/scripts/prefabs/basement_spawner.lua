
local function spawn_basement()
	local inst = CreateEntity()

	inst.entity:AddTransform()

	--[[Non-networked entity]]
	inst.persists = false

	--Auto-remove if not spawned by builder
	inst:DoTaskInTime(0, function(inst)
		local child = SpawnPrefab("basement_entrance_builder")
		if child ~= nil then
			child.Transform:SetPosition(inst.Transform:GetWorldPosition())
			child:OnBuiltFn()
        end
		inst:Remove()
	end)

	if not TheWorld.ismastersim then
		return inst
	end

	return inst
end

return Prefab("basement_spawner", spawn_basement)