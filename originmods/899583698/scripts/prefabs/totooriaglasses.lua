local assets=
{
	Asset("ANIM", "anim/totooriaglasses.zip"),
	Asset("ATLAS", "images/inventoryimages/totooriaglasses.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "totooriaglasses", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")

    if owner.components.totooriastatus then
    	owner.components.totooriastatus.expmod = 2
    end

    inst.onitembuild = function()
        inst.components.finiteuses:Use(1)
    end
    inst:ListenForEvent("DoDeltaExpTTR", inst.onitembuild, owner)

    if TUNING.TTRMODE == false then
		owner.components.builder.ancient_bonus = 4
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner.components.totooriastatus then
    	owner.components.totooriastatus.expmod = 1
    end

    inst:RemoveEventCallback("DoDeltaExpTTR", inst.onitembuild, owner)

    if TUNING.TTRMODE == false then
		owner.components.builder.ancient_bonus = 0
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    
    inst:AddTag("hat")
	
    anim:SetBank("totooriaglasses")
    anim:SetBuild("totooriaglasses")
    anim:PlayAnimation("anim")    
        
    inst:AddComponent("inspectable")

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriaglasses.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)
	
    return inst
end

return Prefab( "common/inventory/totooriaglasses", fn, assets) 
