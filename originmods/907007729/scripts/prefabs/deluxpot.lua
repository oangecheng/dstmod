require "prefabutil"

local cooking = require("cooking")
--local FOODSTCOOK = require("preparedfoods")
local FOODSTCOOK = cooking.recipes["cookpot"]


local assets =
{
    Asset("ANIM", "anim/deluxpot.zip"),
    Asset("ANIM", "anim/cook_pot_food.zip"),
--    Asset("ANIM", "anim/ui_cookpot_1x4.zip"),
}

local prefabs =
{
    "collapse_small",
}


function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

for k, v in pairs(cooking.recipes.cookpot) do
    table.insert(prefabs, v.name)
end

for k,recipe in pairs (FOODSTCOOK) do 

    local rep = shallowcopy(recipe)
    rep.cooktime = rep.cooktime * TUNING.deluxpotconf.CookTime
    AddCookerRecipe("deluxpot", rep) 
end



local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if not inst:HasTag("burnt") and inst.components.stewer.product ~= nil and inst.components.stewer:IsDone() then
        inst.components.lootdropper:AddChanceLoot(inst.components.stewer.product, 1)
    end
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("work_hit")
            inst.AnimState:PushAnimation("work", true)
        elseif inst.components.stewer:IsDone() then
            local mult = inst.components.stewer.productmult or 1
            inst.AnimState:PlayAnimation("done"..mult.."_hit")
            inst.AnimState:PushAnimation("done"..mult, false)
        else
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("idle", false)
        end
    end
end

--anim and sound callbacks

local function startcookfn(inst)
    --print("startcookfn")
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("work", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
        inst.Light:Enable(true)
    end
end

local function onopen(inst)
    --print("onopen")
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open", true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
    end
end

local function onclose(inst)
    --print("onclose")
    if not inst:HasTag("burnt") then 
        if not inst.components.stewer:IsCooking() then
            inst.AnimState:PlayAnimation("idle")
            inst.SoundEmitter:KillSound("snd")
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close")
    end
end

local function spoilfn(inst)
    --print("spoilfn")
    if not inst:HasTag("burnt") then
        inst.components.stewer.product = inst.components.stewer.spoiledproduct
        inst.AnimState:OverrideSymbol("food", "cook_pot_food", inst.components.stewer.product)
    end
end

local function ShowProduct(inst)
    --print("ShowProduct")
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        if IsModCookingProduct(inst.prefab, product) or IsModCookingProduct("cookpot", product) then
            --print("moded!")
            inst.AnimState:OverrideSymbol("food", product, product)
        else
            --print("not moded!")
            inst.AnimState:OverrideSymbol("food", "cook_pot_food", product)
        end
    end
end

local function donecookfn(inst)
    --print("donecookfn")
    if not inst:HasTag("burnt") then
        local mult = inst.components.stewer.productmult or 1
        inst.AnimState:PlayAnimation("work_pst"..mult)        
        inst.AnimState:PushAnimation("done"..mult, false)
        ShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
        inst.Light:Enable(false)
    end
end

local function continuedonefn(inst)
    --print("continuedonefn")
    if not inst:HasTag("burnt") then 
        local mult = inst.components.stewer.productmult or 1
        inst.AnimState:PlayAnimation("done"..mult)
        ShowProduct(inst)
    end
end

local function continuecookfn(inst)
    --print("continuecookfn")
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("work", true)
        inst.Light:Enable(true)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
    end
end

local function harvestfn(inst)
    --print("harvestfn")
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("idle")
    end
end

local function getstatus(inst)
    --print("getstatus")
    return (inst:HasTag("burnt") and "BURNT")
        or (inst.components.stewer:IsDone() and "DONE")
        or (not inst.components.stewer:IsCooking() and "EMPTY")
        or (inst.components.stewer:GetTimeToCook() > 15 and "COOKING_LONG")
        or "COOKING_SHORT"
end

local function onfar(inst)
    --print("onfar")
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("built")
    inst.AnimState:PushAnimation("idle", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
	if inst.components.burnable ~= nil then
            inst.components.burnable.onburnt(inst)
        end
        inst.Light:Enable(false)
    end
end

local function OnHaunt(inst, haunter)
    local ret = false
    --#HAUNTFIX
    --if math.random() <= TUNING.HAUNT_CHANCE_OFTEN then
        --if inst.components.workable then
            --inst.components.workable:WorkedBy(haunter, 1)
            --inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
            --ret = true
        --end
    --end
    if inst.components.stewer ~= nil and
        inst.components.stewer.product ~= "wetgoop" and
        math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        if inst.components.stewer:IsCooking() then
            inst.components.stewer.product = "wetgoop"
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            ret = true
        elseif inst.components.stewer:IsDone() then
            inst.components.stewer.product = "wetgoop"
            inst.components.hauntable.hauntvalue = TUNING.HAUNT_MEDIUM
            continuedonefn(inst)
            ret = true
        end
    end
    return ret
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)
    inst.Transform:SetScale(3, 3, 3)

    inst.MiniMapEntity:SetIcon("deluxpot.tex")
    inst.MiniMapEntity:SetPriority(1)


    inst.Light:Enable(false)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)

    inst:AddTag("structure")

    inst.AnimState:SetBank("deluxpot")
    inst.AnimState:SetBuild("deluxpot")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst:ListenForEvent("onbuilt", onbuilt)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()


    inst:AddComponent("stewer")
    inst:AddComponent("deluxstewer")
    -- A little bit hacky but works
    -- This is needed for ACTION "COOK" wich uses stewer component
    inst.components.stewer = inst.components.deluxstewer

--    inst:AddComponent("stewer")


    inst.components.stewer.onstartcooking = startcookfn
    inst.components.stewer.oncontinuecooking = continuecookfn
    inst.components.stewer.oncontinuedone = continuedonefn
    inst.components.stewer.ondonecooking = donecookfn
    inst.components.stewer.onharvest = harvestfn
    inst.components.stewer.onspoil = spoilfn


    inst:AddComponent("container")
    inst.components.container:WidgetSetup("deluxpot")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    MakeSnowCovered(inst)

    --MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)

    inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end



return Prefab("deluxpot", fn, assets, prefabs),
    MakePlacer("deluxpot_placer", "deluxpot", "deluxpot", "idle",nil,nil,nil,3)
