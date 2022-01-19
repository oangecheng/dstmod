local assets =
{
	Asset("ANIM", "anim/amelia_watch.zip"),
	
	Asset("ATLAS", "images/inventoryimages/amelia_watch_icon.xml"),
    Asset("IMAGE", "images/inventoryimages/amelia_watch_icon.tex"),
    Asset("ATLAS", "images/inventoryimages/amelia_watch_cooldown_icon.xml"),
    Asset("IMAGE", "images/inventoryimages/amelia_watch_cooldown_icon.tex"),

    Asset("INV_IMAGE", "amelia_watch_icon"),
    Asset("INV_IMAGE", "amelia_watch_cooldown_icon"),
}

local TimeLapse = require "modifications/amelia_timelapse"

local watch_cooldown_imagename = "amelia_watch_cooldown_icon"
local watch_ready_imagename = "amelia_watch_icon"

local function ToWatchCooldownUpdate(inst)
    inst.components.inventoryitem.imagename = watch_cooldown_imagename
    inst.components.inventoryitem.atlasname = "images/inventoryimages/amelia_watch_cooldown_icon.xml"
end

local function ToWatchReadyUpdate(inst)
    inst.components.inventoryitem.imagename = watch_ready_imagename
    inst.components.inventoryitem.atlasname = "images/inventoryimages/amelia_watch_icon.xml"
end

local function CheckTimeleapCooldown(inst)
    if inst and inst.components.inventoryitem then
        local owner = inst.components.inventoryitem:GetGrandOwner()
        local current_imagename = inst.components.inventoryitem.imagename
        if owner and owner.components.ameliahistory then
            if owner.components.ameliahistory:IsOnCooldown() and current_imagename == watch_ready_imagename then
                ToWatchCooldownUpdate(inst)
            elseif not owner.components.ameliahistory:IsOnCooldown() and current_imagename == watch_cooldown_imagename then
                ToWatchReadyUpdate(inst)
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pocket_scale")
    inst.AnimState:SetBuild("amelia_watch")
    inst.AnimState:PlayAnimation("idle")
    
    inst.MiniMapEntity:SetIcon("amelia_watch_icon.png")

    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.15, 0.9)

    inst:AddTag("amelia_watch")
    inst:AddTag("nopunch")
    
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "amelia_watch_icon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/amelia_watch_icon.xml"

    inst:AddComponent("inspectable")
    -- inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(TimeLapse)
    inst.components.spellcaster.canusefrominventory = true
    inst.components.spellcaster.quickcast = true
    inst.spelltype = "TIMELEAP"

    MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    if TUNING.AMELIA_WATCH_MAX_USES ~= 9999 then
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.AMELIA_WATCH_MAX_USES)
        inst.components.finiteuses:SetUses(TUNING.AMELIA_WATCH_MAX_USES)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    end

    inst:DoPeriodicTask(0.3, function(inst)
        CheckTimeleapCooldown(inst)
    end)
    return inst
end

return Prefab("amelia_watch", fn, assets)

