local assets =
{
    Asset("ANIM", "anim/swap_watame_katana.zip"),
    Asset("ANIM", "anim/floating_items.zip"),

    
    Asset( "ATLAS", "images/inventoryimages/watame_katana.xml" ),
	Asset( "IMAGE", "images/inventoryimages/watame_katana.tex" ),
}
local CRIT_DMG = TUNING.WATAME_KATANA_ATK_DAMAGE * TUNING.WATAME_KATANA_CRIT_MULTI

local function UpdateDamage(inst, attacker, target)
    local rng = math.random(0, 100)
    local crit_chance = TUNING.WATAME_KATANA_CRIT_CHANCE
    if TUNING.ENABLE_WATAME_KATANA_CRIT_SHOGUN_SET 
    and inst:HasTag("watame_shogun_kabuto") 
    then
        crit_chance = TUNING.WATAME_KATANA_CRIT_CHANCE * 2
    end
    if rng <= crit_chance then
        inst.components.weapon:SetDamage(TUNING.WATAME_KATANA_ATK_DAMAGE)
        -- attacker.SoundEmitter:PlaySound("watame_sounds/watame/watame_katana_slash", nil , 0.5)
    else
        inst.components.weapon:SetDamage(CRIT_DMG)
        attacker.SoundEmitter:PlaySound("watame_sounds/watame/watame_katana_critical_slash", nil , 0.7)
        local coinflip = math.random(0,1)
        if coinflip == 0 then
            target:SpawnChild("shadowstrike_slash_fx")
        else
            target:SpawnChild("shadowstrike_slash2_fx")
        end
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_watame_katana", "swap_watame_katana")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    owner.SoundEmitter:PlaySound("watame_sounds/watame/watame_katana_draw", nil , 0.5)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    owner.SoundEmitter:PlaySound("watame_sounds/watame/watame_katana_sheath", nil , 0.5)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("swap_watame_katana")
    inst.AnimState:SetBuild("swap_watame_katana")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    -- inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.WATAME_KATANA_ATK_DAMAGE)
    inst.components.weapon:SetOnAttack(UpdateDamage)
    -------

    if TUNING.WATAME_KATANA_USAGE ~= 99999 then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.WATAME_KATANA_USAGE)
        inst.components.finiteuses:SetUses(TUNING.WATAME_KATANA_USAGE)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    end


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "watame_katana"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/watame_katana.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("watame_katana", fn, assets)