local assets =
{
    Asset("ANIM", "anim/flare.zip"),
    Asset("ANIM", "anim/medal_rain_bomb.zip"),
    Asset("ANIM", "anim/medal_clear_up_bomb.zip"),
    Asset("ANIM", "anim/flare_water.zip"),
    Asset("INV_IMAGE", "miniflare"),
	Asset("ATLAS", "images/medal_rain_bomb.xml"),
	Asset("ATLAS", "images/medal_clear_up_bomb.xml"),
	Asset("ATLAS_BUILD", "images/medal_rain_bomb.xml",256),
	Asset("ATLAS_BUILD", "images/medal_clear_up_bomb.xml",256),
}

local prefabs =
{
    "miniflare_minimap",
}

local function on_ignite_over(inst)
    --改变天气
	if inst.prefab=="medal_rain_bomb" then
		TheWorld:PushEvent("ms_forceprecipitation", true)
	else
		TheWorld:PushEvent("ms_forceprecipitation", false)
	end
	
	local fx, fy, fz = inst.Transform:GetWorldPosition()

    local random_angle = math.pi * 2 * math.random()
    local random_radius = -(TUNING.MINIFLARE.OFFSHOOT_RADIUS) + (math.random() * 2 * TUNING.MINIFLARE.OFFSHOOT_RADIUS)

    fx = fx + (random_radius * math.cos(random_angle))
    fz = fz + (random_radius * math.sin(random_angle))

    -------------------------------------------------------------
    --生成小地图图标
    local minimap = SpawnPrefab("miniflare_minimap")
    minimap.Transform:SetPosition(fx, fy, fz)
    minimap:DoTaskInTime(TUNING.MINIFLARE.TIME, function()
        minimap:Remove()
    end)

    inst:Remove()
end
--燃放
local function on_ignite(inst)
    --发射后实体就不应该存在了
    inst.persists = false
    inst.entity:SetCanSleep(false)

    inst.AnimState:PlayAnimation("fire")
    inst:ListenForEvent("animover", on_ignite_over)

    inst.SoundEmitter:PlaySound("turnoftides/common/together/miniflare/launch")
end

local function on_dropped(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
end

local function rain_bomb_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("flare")
    inst.AnimState:SetBuild("medal_rain_bomb")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "large", nil, {0.65, 0.4, 0.65})

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_rain_bomb"
	inst.components.inventoryitem.atlasname = "images/medal_rain_bomb.xml"

    inst:AddComponent("burnable")
    inst.components.burnable:SetOnIgniteFn(on_ignite)

    MakeSmallPropagator(inst)
    inst.components.propagator.heatoutput = 0
    inst.components.propagator.damages = false

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("ondropped", on_dropped)
    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("float") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)

    return inst
end

local function clear_up_bomb_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("flare")
    inst.AnimState:SetBuild("medal_clear_up_bomb")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "large", nil, {0.65, 0.4, 0.65})

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_clear_up_bomb"
	inst.components.inventoryitem.atlasname = "images/medal_clear_up_bomb.xml"

    inst:AddComponent("burnable")
    inst.components.burnable:SetOnIgniteFn(on_ignite)

    MakeSmallPropagator(inst)
    inst.components.propagator.heatoutput = 0
    inst.components.propagator.damages = false

    MakeHauntableLaunch(inst)

    inst:ListenForEvent("ondropped", on_dropped)
    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("float") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)

    return inst
end

return Prefab("medal_rain_bomb", rain_bomb_fn, assets, prefabs),
	Prefab("medal_clear_up_bomb", clear_up_bomb_fn, assets, prefabs)
        --MakePlacer("medal_rain_bomb_placer", "flare", "flare", "idle")
