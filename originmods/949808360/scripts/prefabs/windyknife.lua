local assets=
{
	Asset("ANIM", "anim/windyknife.zip"),
	Asset("ATLAS", "images/inventoryimages/windyknife.xml"),
}

local prefabs = {
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "windyknife", "swap_windyknife")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function onattack(inst, attacker, target, skipsanity)
    local chance = 20
    if not attacker then return end
    if not attacker.components.combat then return end
    if not target then return end
    if not target.components.combat then return end

    local mult =
        (   attacker.components.electricattacks ~= nil
        )
        and not (target:HasTag("electricdamageimmune") or
                (target.components.inventory ~= nil and target.components.inventory:IsInsulated()))
        and TUNING.ELECTRIC_DAMAGE_MULT + TUNING.ELECTRIC_WET_DAMAGE_MULT * (target.components.moisture ~= nil and target.components.moisture:GetMoisturePercent() or (target:GetIsWet() and 1 or 0))
        or 1
    local damage = attacker.components.combat:CalcDamage(target, inst, mult)

    if attacker.components.carneystatus and attacker.components.carneystatus.power == 1 then
        damage = damage * (attacker.components.carneystatus.level*5/200 + 1.25)
    end

    if math.random(1,100) <= chance and not target:HasTag("wall") then
        target.components.combat:GetAttacked(attacker, damage)
        local snap = SpawnPrefab("impact")
        snap.Transform:SetScale(3, 3, 3)
        snap.Transform:SetPosition(target.Transform:GetWorldPosition())
        if target.SoundEmitter ~= nil then
            target.SoundEmitter:PlaySound("dontstarve/common/whip_large")
        end
    end
    if inst.components.finiteuses then
        inst.components.windyknifestatus.use = inst.components.finiteuses.current
    end
end

local function repair(inst)
    local repair = inst.components.finiteuses.current/inst.components.finiteuses.total + .2
    if repair >= 1 then repair = 1 end
    inst.components.finiteuses:SetUses(math.floor(repair*inst.components.finiteuses.total))
    inst.components.windyknifestatus.use = inst.components.finiteuses.current
end

local function valuecheck(inst)
    local level = inst.components.windyknifestatus.level
    local amount = math.floor(level/5)
    inst.components.weapon:SetDamage(27+amount)

    if inst.components.finiteuses then
        local percent = inst.components.finiteuses.current/inst.components.finiteuses.total
        inst.components.finiteuses:SetMaxUses(200+level*5)
        inst.components.finiteuses:SetUses(inst.components.windyknifestatus.use)
    end

    local m = math.ceil(15-level/100*15)
    if m <= 1 then m = 1 end
    inst.components.tool:SetAction(ACTIONS.CHOP, 15/m)

    if inst.components.windyknifestatus.level >= 315 and TUNING.wklimit and inst.components.finiteuses then
        inst.components.finiteuses.current = inst.components.finiteuses.total
        inst:RemoveComponent("finiteuses")
        if inst.components.trader then
            inst:RemoveComponent("trader")
        end
    end
end

local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab ~= "goldnugget" then
        return false
    end
    return true
end

local function OnGemGiven(inst, giver, item)
    if TUNING.wklimit then
        if inst.components.windyknifestatus.level < 315 then
            inst.components.windyknifestatus:DoDeltaLevel(1)
        end
    else
        inst.components.windyknifestatus:DoDeltaLevel(1)
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
    valuecheck(inst)
    if TUNING.wklimit then
        if inst.components.windyknifestatus.level < 315 then
            repair(inst)
        end
    else
        repair(inst)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork() 
    inst.entity:AddSoundEmitter()
	
    anim:SetBank("windyknife")
    anim:SetBuild("windyknife")
    anim:PlayAnimation("idle")

    inst:AddTag("windyknife")
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("windyknifestatus")
	
	inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(27)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/windyknife.xml"

	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(200+inst.components.windyknifestatus.level*5)
    inst.components.finiteuses:SetUses(inst.components.windyknifestatus.use)
    --inst.components.finiteuses:SetOnFinished(function() inst.components.equippable:Unequip(inst) end)

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

    inst:DoTaskInTime(0, function() valuecheck(inst) end)
    
    return inst
end


return Prefab( "windyknife", fn, assets, prefabs) 