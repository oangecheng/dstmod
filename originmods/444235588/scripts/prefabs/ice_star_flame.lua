local assets =
{
	Asset("ANIM", "anim/ice_star_flame.zip"),
	Asset("SOUND", "sound/common.fsb"),
}

local lightColour = {0.1, 255/255, 1}
-- heatAnimations = {1, 2, 3, 3, 4, 4, 4, 4, 5, 5}
local heats = {-20, -30, -35, -40, -55, -55, -55, -55, -65, -75}


local function GetHeatFn(inst)
	return heats[inst.components.firefx.level] or -120
end

local function fn()
local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ice_star_flame")
    inst.AnimState:SetBuild("ice_star_flame")
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
    inst.components.firefx.levels =
    {
        {anim="level1", sound="dontstarve/common/campfire", radius=6, intensity=.7, falloff=.50, colour = lightColour, soundintensity=.1},
        {anim="level2", sound="dontstarve/common/campfire", radius=8, intensity=.8, falloff=.50, colour = lightColour, soundintensity=.2},
        {anim="level3_slow", sound="dontstarve/common/campfire", radius=9, intensity=.8, falloff=.44, colour = lightColour, soundintensity=.3},
        {anim="level3", sound="dontstarve/common/campfire", radius=10, intensity=.8, falloff=.41, colour = lightColour, soundintensity=.4},
        {anim="level4", sound="dontstarve/common/campfire", radius=11, intensity=.9, falloff=.39, colour = lightColour, soundintensity=.5},
        {anim="level4", sound="dontstarve/common/campfire", radius=11.5, intensity=.9, falloff=.39, colour = lightColour, soundintensity=.6},
        {anim="level4_fast", sound="dontstarve/common/campfire", radius=12.5, intensity=.9, falloff=.39, colour = lightColour, soundintensity=.7},
        {anim="level4_fast", sound="dontstarve/common/campfire", radius=13, intensity=.9, falloff=.37, colour = lightColour, soundintensity=.8},
        {anim="level5_slow", sound="dontstarve/common/campfire", radius=13.5, intensity=.9, falloff=.35, colour = lightColour, soundintensity=.9},
        {anim="level5", sound="dontstarve/common/campfire", radius=14, intensity=.9, falloff=.33, colour = lightColour, soundintensity=1},
    }
    
	--inst.Transform:SetScale(0.1,0.1,0.1)
    --inst.AnimState:SetFinalOffset(-1)
    --anim:SetTint(0,0,1,1)
	--inst.AnimState:SetAddColour(0, 1, 1 ,0)
	--inst.AnimState:SetAddColour(0.1, 0.5, 1 ,1)

    inst.components.firefx:SetLevel(1)
    inst.components.firefx.usedayparamforsound = true
    return inst
end

return Prefab( "common/fx/ice_star_flame", fn, assets) 
