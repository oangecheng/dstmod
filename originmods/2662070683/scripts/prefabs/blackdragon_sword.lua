local assets = {
    Asset("ANIM", "anim/blackdragon_sword.zip"),
    Asset("ATLAS", "images/inventoryimages/blackdragon_sword.xml"),
    Asset("IMAGE", "images/inventoryimages/blackdragon_sword.tex"),
    Asset("ATLAS", "images/minimap/blackdragon_sword.xml"),
    Asset("IMAGE", "images/minimap/blackdragon_sword.tex"),
}

local fxassets = {
    Asset("ANIM", "anim/blackdragon_sword_fx.zip"),
}

local need = {
    charcoal = 40,
    batwing = 10,
    walrus_tusk = 3,
}

local function UpdateData(inst)
    inst.components.weapon:SetDamage(51 + 2.5 * inst.update["charcoal"])
    local enable = inst.weapontype == "ru" and 0.1 or 0
    inst.components.equippable.walkspeedmult = (1 + 0.1 * inst.update["walrus_tusk"] + enable)
end

local function change(inst,type,must)
    if inst.weapontype ~= type or must then
        inst.weapontype = type
        UpdateData(inst)
        if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
            local owner = inst.components.inventoryitem.owner
            owner.AnimState:OverrideSymbol("swap_object", "blackdragon_sword", type)
            if type == "chu" then
                inst.doubleattack = true  
            else
                if inst.doubleattack then
                    inst.doubleattack = false
                end             
            end
        end
    end
end

local function onequip(inst, owner)
    change(inst,"ru",true)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if inst._owner ~= nil then
        inst:RemoveEventCallback("onhitother", inst.attackblood, inst._owner)
    end
    inst._owner = owner
    inst:ListenForEvent("onhitother", inst.attackblood, owner)
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    inst.doubleattack = false
    if inst._owner ~= nil then
        inst:RemoveEventCallback("onhitother", inst.attackblood, inst._owner)
        inst._owner = nil
    end
end

local function ChangeWeaponType(inst,type)
    change(inst,type)
end

local function AcceptTest(inst, item, giver)
    return need[item.prefab] ~= nil  and (inst.update[item.prefab] < need[item.prefab])
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item  and inst.update[item.prefab] then
        inst.update[item.prefab] = inst.update[item.prefab] + 1
    end
    UpdateData(inst)
end

local function OnLoad(inst, data)
	if data then
		inst.update = data.update
		UpdateData(inst)
	end
end

local function OnSave(inst, data)
	if inst.update ~= nil then
		data.update = inst.update
	end
end

local function useitem(inst)
    change(inst,"ru")
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("blackdragon_sword.tex")

    inst.AnimState:SetBank("blackdragon_sword")
    inst.AnimState:SetBuild("blackdragon_sword")

    inst:AddTag("blackdragon_sword")

    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst, 1)
    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    inst.weapontype = "ru"
    inst.update = {}

    for k, v in pairs(need) do
        inst.update[k] = 0
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/blackdragon_sword.xml"

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(51)
    inst.components.weapon:SetRange(0.8, 0.8)
    
    local olddamage = inst.components.weapon.GetDamage
    inst.components.weapon.GetDamage = function(self, attacker, target)
        return (self.inst.doubleattack and 2 or 1 )* olddamage(self, attacker, target)
    end
    inst.attackblood = function(owner,data)
        if inst.update.batwing < 1 then
            return 
        end
        if data and data.weapon == inst and data.damageresolved ~= nil and data.target then
            if owner.components.health ~= nil and owner.components.health:GetPercent() < 1 and not (data.target:HasTag("wall") or data.target:HasTag("engineering")) then
                owner.components.health:DoDelta(0.01* inst.update.batwing * data.damageresolved)
            end
        end
    end

    inst.components.weapon:SetOnAttack(
        function(inst, owner, target)
            local double = 1
            if inst.doubleattack then
                inst.doubleattack = false
                double = 2
                if target and target:IsValid() then
                    local fx = SpawnPrefab("blackdragon_sword_fx")
                    fx.Transform:SetPosition(target.Transform:GetWorldPosition())               --
                end
            end
        end
    )

    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(AcceptTest)
    inst.components.trader.onaccept = OnGetItemFromPlayer

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)
    
    inst.ChangeWeaponType = ChangeWeaponType

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end



local function PlayRingAnim(proxy)
    local inst = CreateEntity()

    inst:AddTag("FX")
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBank("dragonfly_ground_fx")
    inst.AnimState:SetBuild("blackdragon_sword_fx")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(3)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:ListenForEvent("animover", inst.Remove)
end

local function fxfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddNetwork()
    inst:AddTag("FX")

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, PlayRingAnim)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    inst:DoTaskInTime(1.5, inst.Remove)
    return inst
end

return Prefab("blackdragon_sword_fx", fxfn, fxassets),
        Prefab("blackdragon_sword", fn, assets)




