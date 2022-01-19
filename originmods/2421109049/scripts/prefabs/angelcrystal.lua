local assets =
{
    Asset("ANIM", "anim/angelcrystal.zip"),

    Asset("SOUND", "sound/together.fsb"),

    Asset("ATLAS", "images/inventoryimages/angelcrystal.xml"),
}

local function tryplaysound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:PlaySound(sound)
    end
end

local function trykillsound(inst, id, sound)
    inst._soundtasks[id] = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst.SoundEmitter:KillSound(sound)
    end
end

local function queueplaysound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, tryplaysound, id, sound)
end

local function queuekillsound(inst, delay, id, sound)
    if inst._soundtasks[id] ~= nil then
        inst._soundtasks[id]:Cancel()
    end
    inst._soundtasks[id] = inst:DoTaskInTime(delay, trykillsound, id, sound)
end

local function tryqueueclosingsounds(inst, onanimover)
    inst._soundtasks.animover = nil
    if inst.AnimState:IsCurrentAnimation("proximity_pst") then
        inst:RemoveEventCallback("animover", onanimover)
        --Delay one less frame, since this task is delayed one frame already
        --queueplaysound(inst, 4 * FRAMES, "close", "dontstarve/common/together/book_maxwell/close")
        queuekillsound(inst, 5 * FRAMES, "killidle", "idlesound")
        queueplaysound(inst, 14 * FRAMES, "drop", "dontstarve/common/together/book_maxwell/drop")
    end
end

local function onanimover(inst)
    if inst._soundtasks.animover ~= nil then
        inst._soundtasks.animover:Cancel()
    end
    inst._soundtasks.animover = inst:DoTaskInTime(FRAMES, tryqueueclosingsounds, onanimover)
end

local function stopclosingsounds(inst)
    inst:RemoveEventCallback("animover", onanimover)
    if next(inst._soundtasks) ~= nil then
        for k, v in pairs(inst._soundtasks) do
            v:Cancel()
        end
        inst._soundtasks = {}
    end
end

local function startclosingsounds(inst)
    stopclosingsounds(inst)
    inst:ListenForEvent("animover", onanimover)
    onanimover(inst)
end

local function onturnon(inst)
    if inst._activetask == nil then
        stopclosingsounds(inst)
        if inst.AnimState:IsCurrentAnimation("proximity_loop") then
            --In case other animations were still in queue
            inst.AnimState:PlayAnimation("proximity_loop", true)
        else
            inst.AnimState:PlayAnimation("proximity_pre")
            inst.AnimState:PushAnimation("proximity_loop", true)
        end
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound")
        end
    end
end

local function onturnoff(inst)
    if inst._activetask == nil and not inst.components.inventoryitem:IsHeld() then
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        startclosingsounds(inst)
    end
end

local function doneact(inst)
    inst._activetask = nil
    if inst.components.prototyper.on then
        inst.AnimState:PlayAnimation("proximity_loop", true)
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/active_LP", "idlesound")
        end
    else
        inst.AnimState:PushAnimation("proximity_pst")
        inst.AnimState:PushAnimation("idle", false)
        startclosingsounds(inst)
    end
end

--local function showfx(inst, show)
--    if inst.AnimState:IsCurrentAnimation("use") then
--        if show then
--            inst.AnimState:Show("FX")
--        else
--            inst.AnimState:Hide("FX")
--        end
--    end
--end

local function onuse(inst, hasfx)
    stopclosingsounds(inst)
    SpawnPrefab("wathgrithr_spirit").Transform:SetPosition(inst.Transform:GetWorldPosition())
    --inst.AnimState:PlayAnimation("use")
    --inst:DoTaskInTime(0, showfx, hasfx)
    --inst.SoundEmitter:PlaySound("dontstarve/common/together/book_maxwell/use")
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
    end
    inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), doneact)
end

local function onactivate(inst)
    onuse(inst, true)
end

local function onputininventory(inst)
    if inst._activetask ~= nil then
        inst._activetask:Cancel()
        inst._activetask = nil
    end
    stopclosingsounds(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:KillSound("idlesound")
end

local function ondropped(inst)
    if inst.components.prototyper.on then
        onturnon(inst)
    end
end

local function OnHaunt(inst, haunter)
    if inst.components.prototyper.on then
        onuse(inst, false)
    else
        Launch(inst, haunter, TUNING.LAUNCH_SPEED_SMALL)
    end
    inst.components.hauntable.hauntvalue = TUNING.HAUNT_TINY
    return true
end

local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif (item.prefab ~= "goldnugget" and inst.components.angelcrystalstatus.SCIENCE == 1
        or inst.components.angelcrystalstatus.SCIENCE == 2)
        and(item.prefab ~= "tophat" and inst.components.angelcrystalstatus.MAGIC == 1
        or item.prefab ~= "purplegem" and inst.components.angelcrystalstatus.MAGIC == 2
        or inst.components.angelcrystalstatus.MAGIC == 3)
        and(item.prefab ~= "thulecite" and inst.components.angelcrystalstatus.ANCIENT == 0
        or item.prefab ~= "opalpreciousgem" and inst.components.angelcrystalstatus.ANCIENT == 2
        or inst.components.angelcrystalstatus.ANCIENT == 4)
        and(item.prefab ~= "ice" and inst.components.angelcrystalstatus.SEAFARING == 0
        or inst.components.angelcrystalstatus.SEAFARING == 2)
        and(item.prefab ~= "moonrocknugget" and inst.components.angelcrystalstatus.CELESTIAL == 0
        or inst.components.angelcrystalstatus.CELESTIAL == 1)
        and(item.prefab ~= "moonglass" and inst.components.angelcrystalstatus.MOON_ALTAR == 0
        or inst.components.angelcrystalstatus.MOON_ALTAR == 2)
        and(item.prefab ~= "redgem" and item.prefab ~= "bluegem" and inst.components.angelcrystalstatus.FIRE_STATE == 0
        or item.prefab ~= "redgem" and inst.components.angelcrystalstatus.FIRE_STATE == -1
        or item.prefab ~= "bluegem" and inst.components.angelcrystalstatus.FIRE_STATE == 1)
        and(item.prefab ~= "papyrus" and inst.components.angelcrystalstatus.CARTOGRAPHY == 0
        or inst.components.angelcrystalstatus.CARTOGRAPHY == 2)then
        return false
    end
    return true
end

local function OnGemGiven(inst, giver, item)
    if item.prefab == "goldnugget" and inst.components.angelcrystalstatus.SCIENCE == 1 then
        inst.components.angelcrystalstatus.SCIENCE = 2
    elseif item.prefab == "tophat" and inst.components.angelcrystalstatus.MAGIC == 1 then
        inst.components.angelcrystalstatus.MAGIC = 2
    elseif item.prefab == "purplegem" and inst.components.angelcrystalstatus.MAGIC == 2 then
        inst.components.angelcrystalstatus.MAGIC = 3
    elseif item.prefab == "thulecite" and inst.components.angelcrystalstatus.ANCIENT == 0 then
        inst.components.angelcrystalstatus.ANCIENT = 2
    elseif item.prefab == "opalpreciousgem" and inst.components.angelcrystalstatus.ANCIENT == 2 then
        inst.components.angelcrystalstatus.ANCIENT = 4
    elseif item.prefab == "ice" and inst.components.angelcrystalstatus.SEAFARING == 0 then
        inst.components.angelcrystalstatus.SEAFARING = 2
    elseif item.prefab == "moonrocknugget" and inst.components.angelcrystalstatus.CELESTIAL == 0 then
        inst.components.angelcrystalstatus.CELESTIAL = 1
    elseif item.prefab == "moonglass" and inst.components.angelcrystalstatus.MOON_ALTAR == 0 then
        inst.components.angelcrystalstatus.MOON_ALTAR = 2
    elseif item.prefab == "redgem" and inst.components.angelcrystalstatus.FIRE_STATE ~= 1 then
        inst.components.angelcrystalstatus.FIRE_STATE = 1
    elseif item.prefab == "bluegem" and inst.components.angelcrystalstatus.FIRE_STATE ~= -1 then
        inst.components.angelcrystalstatus.FIRE_STATE = -1
    elseif item.prefab == "papyrus" and inst.components.angelcrystalstatus.CARTOGRAPHY == 0 then
        inst.components.angelcrystalstatus.CARTOGRAPHY = 2
    end
    
    local TechTree = require("techtree")
    inst.components.prototyper.trees = TechTree.Create({SCIENCE = inst.components.angelcrystalstatus.SCIENCE,
                                                        MAGIC = inst.components.angelcrystalstatus.MAGIC,
                                                        ANCIENT = inst.components.angelcrystalstatus.ANCIENT,
                                                        SEAFARING = inst.components.angelcrystalstatus.SEAFARING,
                                                        CELESTIAL = inst.components.angelcrystalstatus.CELESTIAL,
                                                        MOON_ALTAR = inst.components.angelcrystalstatus.MOON_ALTAR,
                                                        CARTOGRAPHY = inst.components.angelcrystalstatus.CARTOGRAPHY})

    if inst.components.angelcrystalstatus.FIRE_STATE == 1 then
        inst:AddComponent("cooker")
        inst:AddComponent("heater")
        inst.components.heater.heat = 150
    elseif inst.components.angelcrystalstatus.FIRE_STATE == -1 then
        inst:RemoveComponent("cooker")
        inst:AddComponent("heater")
        inst.components.heater.heat = -150
        inst.components.heater:SetThermics(false, true)
    end

end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("angelcrystal")
    inst.AnimState:SetBuild("angelcrystal")
    inst.AnimState:PlayAnimation("idle")

    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._activetask = nil
    inst._soundtasks = {}
    inst:AddTag("lightningrod")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/angelcrystal.xml"

    inst:AddComponent("angelcrystalstatus")
    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.onactivate = onactivate
    local TechTree = require("techtree")
    inst.components.prototyper.trees = TechTree.Create({SCIENCE = 0})

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

	inst:AddComponent("hauntable")				--闹鬼
    --inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)		--闹鬼复活

    inst:AddTag("cooker")

    inst:ListenForEvent("onputininventory", onputininventory)
    inst:ListenForEvent("ondropped", ondropped)
    
    inst:DoTaskInTime(.2, function()
        inst.components.prototyper.trees = TechTree.Create({SCIENCE = inst.components.angelcrystalstatus.SCIENCE,
                                                            MAGIC = inst.components.angelcrystalstatus.MAGIC,
                                                            ANCIENT = inst.components.angelcrystalstatus.ANCIENT,
                                                            SEAFARING = inst.components.angelcrystalstatus.SEAFARING,
                                                            CELESTIAL = inst.components.angelcrystalstatus.CELESTIAL,
                                                            MOON_ALTAR = inst.components.angelcrystalstatus.MOON_ALTAR,
                                                            CARTOGRAPHY = inst.components.angelcrystalstatus.CARTOGRAPHY})
        if inst.components.angelcrystalstatus.FIRE_STATE == 1 then
            inst:AddComponent("cooker")
            inst:AddComponent("heater")
            inst.components.heater.heat = 150
        elseif inst.components.angelcrystalstatus.FIRE_STATE == -1 then
            inst:RemoveComponent("cooker")
            inst:AddComponent("heater")
            inst.components.heater.heat = -150
            inst.components.heater:SetThermics(false, true)
        end
    end)

    return inst
end

return Prefab("angelcrystal", fn, assets)
