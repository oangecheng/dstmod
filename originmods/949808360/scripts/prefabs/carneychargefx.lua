local FIRE_COLOUR = { 220/255, 100/255, 0/255 }

local function OnUpdateFade(inst)
    local k
    if inst._fade:value() <= inst._fadeframes then
        inst._fade:set_local(math.min(inst._fade:value() + inst._fadeinspeed, inst._fadeframes))
        k = inst._fade:value() / inst._fadeframes
    else
        inst._fade:set_local(math.min(inst._fade:value() + inst._fadeoutspeed, inst._fadeframes * 2 + 1))
        k = (inst._fadeframes * 2 + 1 - inst._fade:value()) / inst._fadeframes
    end

    inst.Light:SetIntensity(inst._fadeintensity * k)
    inst.Light:SetRadius(inst._faderadius * k)
    inst.Light:SetFalloff(1 - (1 - inst._fadefalloff) * k)

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._fade:value() > 0 and inst._fade:value() <= inst._fadeframes * 2)
    end

    if inst._fade:value() == inst._fadeframes or inst._fade:value() > inst._fadeframes * 2 then
        inst._fadetask:Cancel()
        inst._fadetask = nil
    end
end

local function OnFadeDirty(inst)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
    OnUpdateFade(inst)
end

local function FadeOut(inst)
    inst._fade:set(inst._fadeframes + 1)
    if inst._fadetask == nil then
        inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)
    end
end

local function OnFXKilled(inst)
    if inst.fxcount > 0 then
        inst.fxcount = inst.fxcount - 1
    else
        inst:Remove()
    end
end

local function KillFX(inst, anim)
    if not inst.killed then
        if inst.OnKillFX ~= nil then
            inst:OnKillFX(anim)
        end
        inst.killed = true
        inst.AnimState:PlayAnimation(anim or "pst")
        inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength() + .25, inst.fx ~= nil and OnFXKilled or inst.Remove)
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
        if inst._fade ~= nil then
            FadeOut(inst)
        end
        if inst.fx ~= nil then
            for i, v in ipairs(inst.fx) do
                v:KillFX()
            end
        end
    end
end

local function charge_onkillfx(inst, anim)
    --inst.SoundEmitter:KillSound("loop")
    if anim ~= nil then
        inst.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/beam_stop")
    end
end

local function StarSound(inst, init)
    if not init then
        inst:DoTaskInTime(0, StarSound, true)
    elseif not inst.killed then
        --inst.SoundEmitter:PlaySound("dontstarve/wilson/use_gemstaff")--使用法杖的音效
        --inst.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/beam_stop_fail")--啾一下的音效
        --inst.SoundEmitter:PlaySound("dontstarve/common/together/moonbase/beam_stop")--啾一下的音效2
        inst.SoundEmitter:PlaySound("dontstarve/common/staff_star_create")--烧一下的音效
    end
end

--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/deer_fire_charge.zip"),
}

local prefabs = {}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("deer_fire_charge")
    inst.AnimState:SetBuild("deer_fire_charge")
    inst.AnimState:PlayAnimation("pre")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    --inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/fx/charge_LP", "loop")--循环音效

    inst._fadeframes = 15
    inst._fadeintensity = .8
    inst._faderadius = 2
    inst._fadefalloff = .7
    inst._fadeinspeed = 3
    inst._fadeoutspeed = 1

    inst.entity:AddLight()
    inst.Light:SetColour(unpack(FIRE_COLOUR))
    inst.Light:SetRadius(inst._faderadius)
    inst.Light:SetFalloff(inst._fadefalloff)
    inst.Light:SetIntensity(inst._fadeintensity)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

    inst._fade = net_smallbyte(inst.GUID, "deer_fx._fade", "fadedirty")

    inst._fadetask = inst:DoPeriodicTask(FRAMES, OnUpdateFade)

    inst:AddTag("FX")
    --inst.SoundEmitter:SetParameter("loop", "intensity", 1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("fadedirty", OnFadeDirty)
        return inst
    end

    inst.persists = false

    --if data.sound ~= nil then
    --    inst.SoundEmitter:PlaySound(data.sound)
    --end

    inst.AnimState:PushAnimation("loop")

    inst.KillFX = KillFX
    inst.OnKillFX = charge_onkillfx
    StarSound(inst)

    return inst
end

return Prefab("carneychargefx", fn, assets, #prefabs > 0 and prefabs or nil)
