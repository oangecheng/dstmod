local assets=
{
	Asset("ANIM", "anim/totooriastaff5yellow.zip"),
	Asset("ANIM", "anim/swap_totooriastaff5yellow.zip"),
	
	Asset("ATLAS", "images/inventoryimages/totooriastaff5yellow.xml"),
}

local prefabs = {
"nightstickfire",
}

--白天关灯傍晚开灯
local function lighton(inst, owner)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    if inst.watching == true then
        inst:StopWatchingWorldState("startday", inst.startdayfn)
        inst:StopWatchingWorldState("startdusk", inst.startduskfn)
        inst.watching = nil
    end
    if owner and owner:HasTag("lamp") then return end
    inst._light = SpawnPrefab("minerhatlight")
    inst._light.Light:SetFalloff(0.7)
    inst._light.Light:SetIntensity(.5)
    inst._light.Light:SetRadius(4)
    inst._light.Light:SetColour(255/255,255/255,255/255)
    if owner ~= nil then
        if owner.components.inventoryitem then
            if owner.components.inventoryitem.owner then
                inst._light.entity:SetParent(owner.components.inventoryitem.owner.entity)
            else
                inst._light.entity:SetParent(owner.entity)
            end
            inst.backpackchanging = function(_,data)
                if not inst or not inst.components.inventoryitem or not inst.components.inventoryitem.owner then return end
                lighton(inst, inst.components.inventoryitem.owner)
            end
            if not inst.listendrop then
                inst:ListenForEvent("ondropped", inst.backpackchanging, owner)
                inst.listendrop = true
            end
            if not inst.listenputin then
                inst:ListenForEvent("onputininventory", inst.backpackchanging, owner)
                inst.listenputin = true
            end
        else
            inst._light.entity:SetParent(owner.entity)
            if inst.listendrop then
                inst.listendrop = false
                inst:RemoveEventCallback("ondropped", inst.backpackchanging)
            end
            if inst.listenputin then
                inst.listenputin = false
                inst:RemoveEventCallback("onputininventory", inst.backpackchanging)
            end
        end
    else
        inst._light.entity:SetParent(inst.entity)
        if inst.listendrop then
            inst.listendrop = false
            inst:RemoveEventCallback("ondropped", inst.backpackchanging)
        end
        if inst.listenputin then
            inst.listenputin = false
            inst:RemoveEventCallback("onputininventory", inst.backpackchanging)
        end
    end

    if TheWorld.components.worldstate.data.isday then
        inst._light.Light:SetIntensity(0)
        inst._light.Light:Enable(false)
    end
    if not inst.watching then
        inst.watching = true
        local t = 100
        inst.startdayfn = function()
            if inst._light then
                for i=1, t do
                    inst:DoTaskInTime(i*FRAMES, function()
                        if inst._light then
                            inst._light.Light:SetIntensity(.5-i/t*.5)
                            if i == t then inst._light.Light:Enable(false) end
                        end
                    end)
                end
            end
        end
        inst.startduskfn = function()
            if inst._light then
                inst._light.Light:Enable(true)
                for i=1, t do
                    inst:DoTaskInTime(i*FRAMES, function()
                        if inst._light then
                            inst._light.Light:SetIntensity(i/t*.5)
                        end
                    end)
                end
            end
        end
        inst:WatchWorldState("startday", inst.startdayfn)
        inst:WatchWorldState("startdusk", inst.startduskfn)
    end
end

--武器攻击范围随装备角色的脑残上限变化
local function rangechange(inst)
    if inst.components.inventoryitem.owner ~= nil then
        if inst.components.inventoryitem.owner.components.sanity then
            local ownersanity = inst.components.inventoryitem.owner.components.sanity.max
            local rangemodifer = ((ownersanity / 200)^4+1)/1.5
            inst.components.weapon:SetRange(rangemodifer, rangemodifer + 2)
        end
    end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff5yellow", "swap_totooriastaff5yellow")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    rangechange(inst)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function onattack(inst, attacker, target, skipsanity, owner)
    if not inst or not attacker or not target then return end
	--加入冰杖效果
	if not skipsanity and attacker ~= nil and attacker.components.sanity ~= nil then
        attacker.components.sanity:DoDelta(-TUNING.SANITY_SUPERTINY)
    end

    rangechange(inst)

    if not target:IsValid() then
        return
    end
    
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end
    if target.components.burnable then
        if target.components.burnable:IsBurning() then
            target.components.burnable:Extinguish()
        elseif target.components.burnable:IsSmoldering() then
            target.components.burnable:SmotherSmolder()
        end
    end

    if target.sg ~= nil and not target.sg:HasStateTag("frozen") then
        target:PushEvent("attacked", { attacker = attacker, damage = 0 })
    end

    if target.components.freezable then
        if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner.components.totooriastatus then
            target.components.freezable:AddColdness(1+inst.components.inventoryitem.owner.components.totooriastatus.dengji/20)
        else
            target.components.freezable:AddColdness(1)
        end
        target.components.freezable:SpawnShatterFX()
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddLight()
	inst.entity:AddNetwork() 
	
    anim:SetBank("totooriastaff5yellow")
    anim:SetBuild("totooriastaff5yellow")
    anim:PlayAnimation("idle")
	anim:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	--多用工具
	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 2.5)
    inst.components.tool:SetAction(ACTIONS.MINE, 2)
	if TUNING.canhammer == 1 then
    inst.components.tool:SetAction(ACTIONS.HAMMER,1)
	end
	if TUNING.candig == 1 then
    inst.components.tool:SetAction(ACTIONS.DIG,2)
	end
	
	--加入冰杖攻击音效
	inst:AddTag("icestaff")
    inst:AddTag("extinguisher")

    inst:AddTag("lightbattery")
	
	inst:AddComponent("weapon")
    
    if TUNING.TTRMODE == false then
        inst.components.weapon:SetDamage(60)
    else
        inst.components.weapon:SetDamage(TUNING.MINIFAN_DAMAGE)
    end

	inst.components.weapon:SetRange(8, 10)

	--加入冰杖攻击音效2
	inst.components.weapon:SetProjectile("ice_projectile")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff5yellow.xml"
	
    inst:DoTaskInTime(0.2, function() rangechange(inst) end)
    
    inst.components.inventoryitem:SetOnDroppedFn(lighton)
	inst.components.inventoryitem:SetOnPutInInventoryFn(lighton)
    lighton(inst, inst.components.inventoryitem.owner)
	
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
	--加速
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	--inst.components.equippable.dapperness = TUNING.CRAZINESS_MED /4*3
    
    return inst
end


return Prefab( "common/inventory/totooriastaff5yellow", fn, assets, prefabs) 
