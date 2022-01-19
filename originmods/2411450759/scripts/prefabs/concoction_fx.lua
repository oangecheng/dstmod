local assets =
{
    Asset("ANIM", "anim/quagmire_portaldrip_fx.zip"),
    Asset("ANIM", "anim/lavaarena_ember_particles_fx.zip"),
}

local prefabs =
{
}

local function conc_poison_drip_fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("NOBLOCK")
    inst:AddTag("FX")
    inst.AnimState:SetBank("quagmire_portaldrip_fx")
    inst.AnimState:SetBuild("quagmire_portaldrip_fx")
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:PlayAnimation("idle", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
       
    return inst
end


local function conc_poison_particle_fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("NOBLOCK")
    inst:AddTag("FX")
    inst.AnimState:SetBank("ember_particles")
    inst.AnimState:SetBuild("lavaarena_ember_particles_fx")
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetAddColour(22/255,128/255,14/255, 1)
    inst.AnimState:PlayAnimation("pre", false)
    inst.AnimState:PushAnimation("loop", false)
    inst.AnimState:PushAnimation("pst", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
       
    return inst
end

local function conc_sweat_fx_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("NOBLOCK")
    inst:AddTag("FX")
    inst.AnimState:SetBank("waterballoon")
    inst.AnimState:SetBuild("waterballoon")
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetScale(0.8, 0.8, 0.8)
    inst.AnimState:PlayAnimation("used", false)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
       
    return inst
end


return Prefab("conc_poison_drip_fx", conc_poison_drip_fx_fn, assets, prefabs),
       Prefab("conc_poison_particle_fx", conc_poison_particle_fx_fn, assets, prefabs),
       Prefab("conc_sweat_fx", conc_sweat_fx_fn, assets, prefabs)
