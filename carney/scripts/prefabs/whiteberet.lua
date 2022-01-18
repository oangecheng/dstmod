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

local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab == "walrushat" then
        return true
    elseif item.prefab == "silk" then
        return true
    end
    return true
end

local function OnGemGiven(inst, giver, item)
    if item.prefab == "walrushat" then
        inst.components.whiteberetstatus.dapperness = inst.components.whiteberetstatus.dapperness + 1
        inst.components.equippable.dapperness = inst.components.whiteberetstatus.dapperness
        inst.components.fueled.currentfuel = inst.components.fueled.maxfuel
    elseif item.prefab == "silk" then
        inst.components.whiteberetstatus.insulator = inst.components.whiteberetstatus.insulator + 1
        inst.components.insulator:SetInsulation(inst.components.whiteberetstatus.insulator)
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
    inst.components.equippable.dapperness = inst.components.whiteberetstatus.dapperness
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(inst.components.whiteberetstatus.insulator)

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = FUELTYPE.USAGE
    inst.components.fueled:InitializeFuelLevel(TUNING.WALRUSHAT_PERISHTIME)
    inst.components.fueled:SetDepletedFn(inst.Remove)
    
    return inst
end

return Prefab( "whiteberet", fn, assets) 
