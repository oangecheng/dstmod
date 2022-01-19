local assets=
{
	Asset("ANIM", "anim/whiteberet.zip"),
	Asset("ATLAS", "images/inventoryimages/whiteberet.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "whiteberet", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAIR_HAT")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end

end

local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif (item.prefab ~= "walrushat" and inst.components.whiteberetstatus.Walrushat == 0
        or inst.components.whiteberetstatus.Walrushat == 1)
        and (item.prefab ~= "beefalohat" and inst.components.whiteberetstatus.Beefalohat == 0
        or inst.components.whiteberetstatus.Beefalohat == 1)
        and (item.prefab ~= "eyebrellahat" and inst.components.whiteberetstatus.Eyebrellahat == 0
        or inst.components.whiteberetstatus.Eyebrellahat == 1)then
        return false
    end
    return true
end

local function OnGemGiven(inst, giver, item)
    if (item.prefab == "walrushat") then	--海象贝雷帽，san+6增益
        inst.components.whiteberetstatus.Walrushat = 1
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED*3
        inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        --inst.components.fueled.currentfuel = inst.components.fueled.maxfuel
    elseif (item.prefab == "beefalohat") then -- 牛帽，保暖240
        inst.components.whiteberetstatus.Beefalohat = 1
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED*3)
        inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        --inst.components.fueled.currentfuel = inst.components.fueled.maxfuel
    elseif (item.prefab == "eyebrellahat") then --眼球伞完全防雨，延缓过热
        inst.components.whiteberetstatus.Eyebrellahat = 1
        inst.components.waterproofer:SetEffectiveness(1)
		inst.components.equippable.insulated = true		--绝缘防电
        inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
        --inst.components.fueled.currentfuel = inst.components.fueled.maxfuel
    end
    if (inst.components.whiteberetstatus.Walrushat == 1 and inst.components.whiteberetstatus.Beefalohat == 1 and inst.components.whiteberetstatus.Eyebrellahat == 1) then
        inst:RemoveComponent("trader")
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    
    inst:AddTag("hat")
	
    anim:SetBank("whiteberet")
    anim:SetBuild("whiteberet")
    anim:PlayAnimation("anim")    
        
    inst:AddComponent("inspectable")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("whiteberetstatus")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/whiteberet.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

	inst:AddTag("waterproofer")
	inst:AddComponent("waterproofer")	--眼球伞升级需要这个组件
    inst.components.waterproofer:SetEffectiveness(0.2)
	inst.components.equippable.insulated = false		--无绝缘防电

    inst:DoTaskInTime(.2, function()
        if inst.components.whiteberetstatus.Walrushat == 1 then
            inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED*3
        end
        if inst.components.whiteberetstatus.Beefalohat == 1 then
            inst.components.insulator:SetInsulation(TUNING.INSULATION_MED*3)
        end
        if inst.components.whiteberetstatus.Eyebrellahat == 1 then
            inst.components.waterproofer:SetEffectiveness(1)
        end
        if (inst.components.whiteberetstatus.Walrushat == 1 and inst.components.whiteberetstatus.Beefalohat == 1 and inst.components.whiteberetstatus.Eyebrellahat == 1) then
            inst:RemoveComponent("trader")
        end
    end)
    
    return inst
end

return Prefab( "whiteberet", fn, assets) 
