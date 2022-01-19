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

    if inst.components.fueled ~= nil then
        inst.components.fueled:StartConsuming()
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

    if inst.components.fueled ~= nil then
        inst.components.fueled:StopConsuming()
    end
end


local function OnIsSummer(inst, issummer)
    if issummer then
        inst.components.insulator:SetSummer()
    else
        inst.components.insulator:SetWinter()
    end
end


local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab == "walrushat" then
        return true
    elseif item.prefab == "silk" then
        return true
    elseif item.prefab == "pigskin" then
        return true
    end
    return false
end

local function OnGemGiven(inst, giver, item)

    -- 使用海象帽升级精神恢复，每个海象帽只能 +1 精神恢复
    -- 数值2是帽子初始属性，精神 +6
    if item.prefab == "walrushat" then
        local dapperness = inst.components.whiteberetstatus.dapperness
        inst.components.whiteberetstatus.dapperness = dapperness + 1
        inst.components.equippable.dapperness = ((dapperness + 1) / 3 + 2)) * TUNING.DAPPERNESS_MED
        inst.components.fueled.currentfuel = inst.components.fueled.maxfuel
    end
    
    -- 使用蜘蛛网升级保暖
    -- 每个蜘蛛网 +1 保暖
    if item.prefab == "silk" then
        local insulator = inst.components.whiteberetstatus.insulator
        inst.components.whiteberetstatus.insulator = insulator + 1
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED + insulator + 1)
    end

    -- 使用猪皮升级防水
    -- 每个猪皮 +1% 的防水
    if item.prefab == "pigskin" then
        local waterproofer = inst.components.whiteberetstatus.waterproofer
        inst.components.whiteberetstatus.waterproofer = waterproofer + 1
        inst.components.waterproofer:SetEffectiveness(.2 + (waterproofer + 1) / 100)
    end

    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()
    
    inst:AddTag("hat")
      -- 添加防水标签
    inst:AddTag("waterproofer")
	
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
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    -- 添加保暖组件
    inst:AddComponent("insulator")

    -- 添加给予组件
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

    -- 添加可修复组件
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.WALRUSHAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)

    -- 初始化帽子属性
    -- 精神恢复/保暖/防水
    inst:DoTaskInTime(.2, function()
        inst.components.equippable.dapperness = (inst.components.whiteberetstatus.dappernes / 3 + 2) * TUNING.DAPPERNESS_MED
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED + inst.components.whiteberetstatus.insulator)
        inst.components.waterproofer:SetEffectiveness(.2 + inst.components.whiteberetstatus.waterproofer / 100)
    end)

    -- 监听季节变化
    inst:WatchWorldState("issummer", OnIsSummer)
    
    return inst
end

return Prefab( "whiteberet", fn, assets) 
