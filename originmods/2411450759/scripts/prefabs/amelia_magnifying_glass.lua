local assets =
{
    Asset("ANIM", "anim/amelia_magnifying_glass.zip"),
    Asset("ANIM", "anim/swap_amelia_magnifying_glass.zip"),

    Asset("ATLAS", "images/inventoryimages/amelia_magnifying_glass_icon.xml"),
    Asset("IMAGE", "images/inventoryimages/amelia_magnifying_glass_icon.tex"),

    Asset("INV_IMAGE", "amelia_magnifying_glass_icon"),
}


local function onisday(inst)
    if TheWorld.state.isday and not TheWorld.state.israining then
        if not inst.components.lighter then
            inst:AddComponent("lighter")
        end
    else
        if inst.components.lighter then
            inst:RemoveComponent("lighter")
        end
    end
    if inst.components.fueled ~= nil then
        inst.components.fueled:SetUpdateFn()
        inst.components.fueled.rate = 0.1
    end
end


local discovered = {}

local function onequip(inst, owner)
    inst.components.burnable:Ignite()
    owner.AnimState:OverrideSymbol("swap_object", "swap_amelia_magnifying_glass", "swap_amelia_magnifying_glass")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    if owner:HasTag("amelia") then
        inst.finder = inst:DoPeriodicTask(1.2,function (inst)
            local x,y,z = owner.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,y,z, 20)
            for _, value in pairs(ents) do
                if value and value:IsValid() then
                    if value:HasTag("hostile") then
                        local found  = SpawnPrefab("amelia_hidden_red")
                        value:AddChild(found)
                        table.insert(discovered,found)
                    elseif value:HasTag("_combat") and value ~= owner and not value:HasTag("wall") then
                        if value.components.combat:TargetIs(owner) then
                            local found  = SpawnPrefab("amelia_hidden_red")
                            value:AddChild(found)
                            table.insert(discovered,found)
                        else
                            local found  = SpawnPrefab("amelia_hidden_green")
                            value:AddChild(found)
                            table.insert(discovered,found)
                        end
                    elseif value.components.spawner and value.components.spawner:IsOccupied() then
                        local found  = SpawnPrefab("amelia_hidden_blue")
                        value:AddChild(found)
                    end
                end
            end
        end)
        owner:AddTag("detective_glasses")
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
    if owner:HasTag("amelia") then
        if inst.finder then
            inst.finder:Cancel()
        end
        for _, value in pairs(discovered) do
            if value then
                value:Remove()
            end
        end
        owner:RemoveTag("detective_glasses")
    end
    inst.components.burnable:Extinguish()
end

local function onpocket(inst, owner)
    inst.components.burnable:Extinguish()
end

local function onattack(weapon, attacker, target)
    --target may be killed or removed in combat damage phase
    if target ~= nil and target:IsValid() and target.components.burnable ~= nil and math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT * target.components.burnable.flammability and weapon.components.lighter then
        target.components.burnable:Ignite(nil, attacker)
    end
end

local function onfuelchange(newsection, oldsection, inst)
    if newsection <= 0 then
        --when we burn out
        if inst.components.burnable ~= nil then
            inst.components.burnable:Extinguish()
        end
        local equippable = inst.components.equippable
        if equippable ~= nil and equippable:IsEquipped() then
            local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
            if owner ~= nil then
                local data =
                {
                    prefab = inst.prefab,
                    equipslot = equippable.equipslot,
                    announce = "ANNOUNCE_AMELIA_MAGNIFYING_GLASS",
                }
                inst:Remove()
                owner:PushEvent("itemranout", data)
                return
            end
        end
        inst:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amelia_magnifying_glass")
    inst.AnimState:SetBuild("amelia_magnifying_glass")
    inst.AnimState:PlayAnimation("idle")
    

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)

    inst:AddTag("weapon")

    inst.entity:SetPristine()

    -- inst.spelltype = "INVESTIGATE"

    if not TheWorld.ismastersim then
        return inst
    end


    -------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)

    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(TUNING.SPEAR_USES)
    -- inst.components.finiteuses:SetUses(TUNING.SPEAR_USES)

    -- inst.components.finiteuses:SetOnFinished(inst.Remove)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "amelia_magnifying_glass_icon"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/amelia_magnifying_glass_icon.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnPocket(onpocket)
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    
    inst:AddComponent("burnable")
    inst.components.burnable.canlight = false
    inst.components.burnable.fxprefab = nil

    -----------------------------------
    if not TUNING.AMELIA_MAGNIFYING_GLASS_DUR then
        inst:AddComponent("fueled")
        inst.components.fueled:SetSectionCallback(onfuelchange)
        inst.components.fueled:InitializeFuelLevel(TUNING.TORCH_FUEL)
        inst.components.fueled:SetDepletedFn(inst.Remove)
        inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    end

    -- inst:WatchWorldState("isday", onisday)
    
    inst:DoPeriodicTask(1,onisday)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("amelia_magnifying_glass", fn, assets)