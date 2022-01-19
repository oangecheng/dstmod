local assets =
{
    Asset("ANIM", "anim/float_fx.zip"),
}

local prefabs =
{
}

local function setcolor(inst,r,g,b,a)
    inst.AnimState:SetAddColour(r/255,g/255,b/255, a)
end

local function common_fn(color)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.persists = false

    inst:AddTag("NOBLOCK")
    inst:AddTag("FX")
    inst:AddTag("ignorewalkableplatforms")
    
    inst:AddComponent("amelia_transparent")

    inst.AnimState:SetBuild("farm_plant_happiness")
    inst.AnimState:SetBank("farm_plant_happiness")
    inst.AnimState:PlayAnimation("happy")
    if color then
        if color == "green" then
            setcolor(inst,0,255,0,0)
        elseif color == "red" then
            setcolor(inst,255,0,0,0)
        elseif color == "blue" then
            setcolor(inst,0,0,255,0)
        end
    end

    inst.entity:SetPristine()

    inst:DoTaskInTime(2.2,function (inst)
        inst:Remove()
    end)

    if not TheWorld.ismastersim then
        return inst
    end
       
    return inst
end


local function red()
    return common_fn("red")
end

local function green()
    return common_fn("green")
end


local function blue()
    return common_fn("blue")
end

return Prefab("amelia_hidden_yellow", common_fn, assets, prefabs),
Prefab("amelia_hidden_red", red, assets, prefabs),
Prefab("amelia_hidden_green", green, assets, prefabs),
Prefab("amelia_hidden_blue", blue, assets, prefabs)
