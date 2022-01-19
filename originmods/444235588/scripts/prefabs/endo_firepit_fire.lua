local assets =
{
	Asset("ANIM", "anim/endo_firepit_fire.zip"),
	Asset("SOUND", "sound/common.fsb"),
}

--local heats = {-20, -30, -35, -40, -55, -55, -55, -55, -65, -75}
local heats = {-25, -35, -40, -55}

local function GetHeatFn(inst)
	return heats[inst.components.firefx.level] or -120
end

local function GetHeatFn(inst)
	return heats[inst.components.firefx.level] or 20
end

local firelevels =
{
    {anim="level1", sound="dontstarve/common/campfire", radius=4, intensity=.4, falloff=.66, colour = {0.1, 255/255, 1}, soundintensity=.1},
    {anim="level2", sound="dontstarve/common/campfire", radius=5, intensity=.6, falloff=.55, colour = {0.1, 255/255, 1}, soundintensity=.3},
    {anim="level3", sound="dontstarve/common/campfire", radius=8, intensity=.8, falloff=.44, colour = {0.1, 255/255, 1}, soundintensity=.6},
    {anim="level4", sound="dontstarve/common/campfire", radius=10, intensity=.9, falloff=.33, colour = {0.1, 255/255, 1}, soundintensity=1},
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deluxe_firepit_fire")
    inst.AnimState:SetBuild("deluxe_firepit_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(-1)
    
    inst:AddTag("FX")

    --HASHEATER (from heater component) added to pristine state for optimization
    inst:AddTag("HASHEATER")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("heater")
    inst.components.heater.heatfn = GetHeatFn
    inst.components.heater:SetThermics(false, true)

    inst:AddComponent("firefx")
    inst.components.firefx.levels = firelevels
    inst.components.firefx:SetLevel(1)
    inst.components.firefx.usedayparamforsound = true

	inst.AnimState:SetAddColour(0.1, 0.5, 1 ,1)

    return inst
end

return Prefab("common/fx/endo_firepit_fire", fn, assets)