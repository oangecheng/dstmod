local assets =
{
    Asset("ANIM", "anim/mandrakeberry.zip"),
    Asset("ATLAS", "images/mandrakeberry.xml"),
	Asset("ANIM", "anim/seeds.zip"),
    Asset("ATLAS", "images/mandrake_seeds.xml"),
	Asset("ATLAS_BUILD", "images/mandrake_seeds.xml",256),
}

local function onEat(inst,eater)
	local grogginess = eater.components.grogginess
	if grogginess ~= nil then 
		grogginess:AddGrogginess(2, 6)
	elseif eater.components.sleeper ~= nil then
		eater.components.sleeper:AddSleepiness(5, 10)
	end
	--概率掉落种子
	if math.random()<TUNING_MEDAL.MANDRAKEBERRY_SEED_CHANCE then
		if inst.components.lootdropper then
			inst.components.lootdropper:SpawnLootPrefab("mandrake_seeds")
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("mandrakeberry")
    inst.AnimState:SetBuild("mandrakeberry")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("slingshotammo")
	inst:AddTag("reloaditem_ammo")
	
	MakeInventoryFloatable(inst,"med",0.1,0.65)
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("tradable")
	
	inst:AddComponent("reloaditem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)--3天
    inst.components.perishable:StartPerishing()
    inst.components.perishable:SetOnPerishFn(inst.Remove)--过期直接消失

    inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING_MEDAL.MANDRAKEBERRY_HEALTHVALUE
	inst.components.edible.sanityvalue = TUNING_MEDAL.MANDRAKEBERRY_SANITYVALUE
    inst.components.edible.hungervalue = TUNING_MEDAL.MANDRAKEBERRY_HUNGERVALUE
	inst.components.edible:SetOnEatenFn(onEat)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "mandrakeberry"
    inst.components.inventoryitem.atlasname = "images/mandrakeberry.xml"

    return inst
end
--曼德拉种子
local function seed_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)

    inst.entity:AddNetwork()
	MakeInventoryFloatable(inst)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end


    inst.AnimState:SetBank("seeds")
    inst.AnimState:SetBuild("seeds")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.SEEDS
	inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2
	
	inst:AddComponent("cookable")
    inst.components.cookable.product = "seeds_cooked"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERSLOW)--40天
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "mandrake_seeds"
    inst.components.inventoryitem.atlasname = "images/mandrake_seeds.xml"
	
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)
    MakeHauntableLaunchAndPerish(inst)

    return inst
end

return Prefab( "mandrakeberry", fn, assets),
	Prefab( "mandrake_seeds", seed_fn, assets)

