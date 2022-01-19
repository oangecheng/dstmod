local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")

    --inst.AnimState:SetBank("seffc")
    --inst.AnimState:SetBuild("seffc")
    --inst.AnimState:PlayAnimation("anim")
    --inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(5, function() inst:Remove() end)

    inst.persists = false
    return inst
end

return Prefab("ttrsoundprefab", fn)