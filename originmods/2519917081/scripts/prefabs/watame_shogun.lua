local assets =
{
    Asset("ANIM", "anim/watame_shogun.zip"),

    Asset( "ATLAS", "images/inventoryimages/watame_shogun.xml" ),
	Asset( "IMAGE", "images/inventoryimages/watame_shogun.tex" ),
}

local function OnBlocked(owner)
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_scalemail")
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "watame_shogun", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAIR_HAT")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end

    owner:AddTag("watame_shogun_kabuto")

    if owner.components and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:SetModifier(inst, TUNING.WATAME_SHOGUN_ATK_BUFF, "watame_shogun_dmg_mod")
    end

    inst:ListenForEvent("blocked", OnBlocked, owner)
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

    owner:RemoveTag("watame_shogun_kabuto")

    if owner.components and owner.components.combat then
        owner.components.combat.externaldamagemultipliers:RemoveModifier(inst, "watame_shogun_dmg_mod")
    end

    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("watame_shogun")
    inst.AnimState:SetBuild("watame_shogun")
    inst.AnimState:PlayAnimation("idle")
    local s = 1.25
    inst.AnimState:SetScale(s,s,s)

    inst:AddTag("hat")

    MakeInventoryFloatable(inst, "small", 0.2, 0.80)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "watame_shogun"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/watame_shogun.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("armor")
    if TUNING.WATAME_SHOGUN_DURABILITY == 99999 then
        inst.components.armor:InitIndestructible(TUNING.WATAME_SHOGUN_ABSORPTION)
    end

    inst.components.armor:InitCondition(TUNING.WATAME_SHOGUN_DURABILITY, TUNING.WATAME_SHOGUN_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_SMALL)
    
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation(TUNING.WATAME_SHOGUN_COLD_INSULATION)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("watame_shogun", fn, assets)
