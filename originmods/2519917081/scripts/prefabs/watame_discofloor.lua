local CheckPlayerOnDanceFloor = require "modifications.watame_night_fever_floor"

local function makefloor(main,name)
local assets =
{
    Asset("ANIM", "anim/watame_discofloor.zip")
}
    local function RemoveFloor(inst)
        local inital = 20
        inst.DeathCounter = inital
        inst:DoPeriodicTask(0.05,function (inst)
            inst.DeathCounter = inst.DeathCounter-1
            inst.Transform:SetScale(
                inst.DeathCounter/inital,
                inst.DeathCounter/inital,
                inst.DeathCounter/inital)
            if inst.DeathCounter < 0 then
                inst:Remove()
            end
        end)
    end

    local function spawnfloors(inst)
        local size = 10
        local offset = 0.5
        local scale = size * inst.mains *(offset + 1)
        inst.AnimState:SetScale(scale,scale,scale)
        local floors = {}
        for i = 1, size, 1 do
            for j = 1, size, 1 do
                local floor = inst:SpawnChild("watame_floor")
                local r = 0
                local g = 0
                local b = 0
                local color = math.random(1,3)
                if color == 1 then
                    r = 1
                    g = math.random(0,1)
                    b = math.random(0,1)
                elseif color == 2 then
                    g = 1
                    r = math.random(0,1)
                    b = math.random(0,1)
                else
                    b = 1
                    g = math.random(0,1)
                    r = math.random(0,1)
                end
                floor.Light:Enable(true)
                floor.Light:SetRadius(1)
                floor.Light:SetFalloff(1)
                floor.Light:SetIntensity(0.7)
                floor.Light:SetColour(r, g, b)

                -- floor.Transform:SetPosition(x+i-(size*(offset + 1.15)/2)+(i*offset),y,z+j-(size*(offset + 1.15)/2)+(j*offset))
                floor.Transform:SetPosition(i-(size*(offset + 1.15)/2)+(i*offset),0,j-(size*(offset + 1.15)/2)+(j*offset))
                floor.AnimState:SetMultColour(r, g, b, 1)
                inst.floors = table.insert(floors,floor)
            end
        end
    end

    local function rgbcolor(inst)
        local r = 0
        local g = 0
        local b = 0
        local color = math.random(1,3)
        if color == 1 then
            r = 1
            g = math.random(0,1)
            b = math.random(0,1)
        elseif color == 2 then
            g = 1
            r = math.random(0,1)
            b = math.random(0,1)
        else
            b = 1
            g = math.random(0,1)
            r = math.random(0,1)
        end
        inst.Light:SetColour(r, g, b)
        inst.AnimState:SetMultColour(r,g,b,1)

    end

    local function spawnspotlights(inst)
        local size = 4
        local offset = 6
        for i = 1, size, 1 do
            local spotlight1 = inst:SpawnChild("watame_spotlight")
            spotlight1.AnimState:PlayAnimation("idleup1",true)
            local spotlight2 = inst:SpawnChild("watame_spotlight")
            spotlight2.AnimState:PlayAnimation("idleup2",true)
            if i < ((size/4) + 1) then
                spotlight1.Transform:SetPosition(offset,0,offset)
                spotlight2.Transform:SetPosition(offset,0,offset)
            elseif i < ((size/4)*2 + 1) then
                spotlight1.Transform:SetPosition(-offset,0,offset)
                spotlight2.Transform:SetPosition(-offset,0,offset)
            elseif i < ((size/4)*3 + 1) then
                spotlight1.Transform:SetPosition(-offset,0,-offset)
                spotlight2.Transform:SetPosition(-offset,0,-offset)
            else
                spotlight1.Transform:SetPosition(offset,0,-offset)
                spotlight2.Transform:SetPosition(offset,0,-offset)
            end
            rgbcolor(spotlight1)
            spotlight1:DoPeriodicTask(1,function ()
                rgbcolor(spotlight1)
                -- spotlight1.Transform:SetRotation(360/math.random(1,4))
            end)
            rgbcolor(spotlight2)
            spotlight2:DoPeriodicTask(1,function ()
                rgbcolor(spotlight2)
                -- spotlight2.Transform:SetRotation(360/math.random(1,4))
            end)
        end
    end

    local function fn()
        local inst = CreateEntity()
    
    
        inst.entity:AddLight()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()


        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
    
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
    
        inst.AnimState:SetBank("watame_discofloor")
        inst.AnimState:SetBuild("watame_discofloor")
        inst.AnimState:PlayAnimation("spawn")
        inst.RemoveFloor = RemoveFloor
        
        inst.mains = 1.8
        local life = 0.8
        inst.AnimState:SetScale(inst.mains,inst.mains,inst.mains)
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end
        inst:AddComponent("timer")
        if main then
            inst.AnimState:SetMultColour(0,0,0,1)
            spawnfloors(inst)
            spawnspotlights(inst)
            inst:DoPeriodicTask(life,spawnfloors)
            inst.discoball = inst:SpawnChild("watame_discoball")
            inst.discoball.Transform:SetPosition(0,5,0)
            inst.discoball.AnimState:SetMultColour(252/255, 228/255, 129/255,1)
            -- --#region TESTING
            -- inst.components.timer:StartTimer("life", 20 + 0.2)
            -- inst:ListenForEvent("timerdone", function (inst,data)
            --     if data.name == "life" then
            --         inst:Remove()
            --     end
            -- end)
            -- --#endregion TESTING
        else
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            inst.components.timer:StartTimer("life", life + 0.2)
            inst:ListenForEvent("timerdone", function (inst,data)
                if data.name == "life" then
                    inst:Remove()
                end
            end)
            inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
            -- inst.AnimState:SetAddColour(1,1,1,1)
            inst:AddTag("NOBLOCK")
            inst.AnimState:SetSortOrder(4)
        end
        inst.persists = false
    
        return inst
    end

    return Prefab(name, fn, assets)
end
local discoball_assets = {
    Asset("ANIM", "anim/watame_discoball.zip")
}
local function discoball()
    local inst = CreateEntity()
    
    
        inst.entity:AddLight()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

    
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
    
        inst.AnimState:SetBank("watame_discoball")
        inst.AnimState:SetBuild("watame_discoball")
        inst.AnimState:PlayAnimation("spawn")
        inst.AnimState:PlayAnimation("idle",true)

        local scale = 1.2
        inst.AnimState:SetScale(scale,scale,scale)
        inst.entity:SetPristine()
    
        if not TheWorld.ismastersim then
            return inst
        end

        inst.Light:Enable(true)
        inst.Light:SetRadius(1)
        inst.Light:SetFalloff(1)
        inst.Light:SetIntensity(0.66)
        inst.Light:SetColour(1, 1, 1)
        inst.persists = false

        CheckPlayerOnDanceFloor(inst)
    
        return inst
end

local spotlights_assets = {
    Asset("ANIM", "anim/watame_spotlight.zip")
}

local function spotlights()
    local inst = CreateEntity()
    
    
    inst.entity:AddLight()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    -- inst.Transform:SetFourFaced()

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.AnimState:SetBank("watame_spotlight")
    inst.AnimState:SetBuild("watame_spotlight")
    -- inst.AnimState:PlayAnimation("idle",true)

    local scale = 1.2
    inst.AnimState:SetScale(scale,scale,scale)
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.Light:Enable(true)
    inst.Light:SetRadius(1)
    inst.Light:SetFalloff(0.66)
    inst.Light:SetIntensity(0.66)
    inst.persists = false

    return inst
end

return makefloor(true,"watame_discofloor"),
makefloor(false,"watame_floor"),
Prefab("watame_discoball",discoball,discoball_assets),
Prefab("watame_spotlight",spotlights,spotlights_assets)