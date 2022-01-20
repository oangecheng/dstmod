local assets =
{
    Asset("ANIM", "anim/kj_sw.zip"),
	Asset("ATLAS", "images/inventoryimages/kj.xml"),
    Asset("IMAGE", "images/inventoryimages/kj.tex"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
    --owner.AnimState:OverrideSymbol("swap_body", "kj_sw", "kj_sw")                     
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner)  
    --owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("kj")
    inst.AnimState:SetBuild("kj_sw")
    inst.AnimState:PlayAnimation("anim")
	
	 inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/kj.xml"  
    
    inst:AddComponent("waterproofer")  
    inst.components.waterproofer:SetEffectiveness(1)

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, 0.85)
	inst.components.armor.indestructible = true
	inst:AddTag("hide_percentage")			--隐藏百分比
	
    inst:AddComponent("equippable") 
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY 
	inst.components.equippable.insulated = true			--绝缘
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    return inst
end

return Prefab("kj", fn, assets)
