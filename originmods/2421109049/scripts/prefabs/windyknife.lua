local assets=
{
	Asset("ANIM", "anim/windyknife.zip"),
	Asset("ATLAS", "images/inventoryimages/windyknife.xml"),
}

local prefabs = {
}

local function onuse(inst)
	inst.toool = not inst.toool
	if inst.toool then
		inst.components.named:SetName("工具短剑")
		inst:AddComponent("tool")
		inst.components.tool:SetAction(ACTIONS.CHOP, 5)
		inst.components.tool:SetAction(ACTIONS.MINE, 4)
		inst.components.tool:SetAction(ACTIONS.DIG)
		inst.components.tool:SetAction(ACTIONS.HAMMER)
		inst.components.tool:SetAction(ACTIONS.NET)
	else
		inst.components.named:SetName("微风短剑")
		inst:RemoveComponent("tool")
	end
	if inst.components.inventoryitem.owner then
	inst.components.inventoryitem.owner.components.talker:Say(inst.toool and "切换成功！完美打工人！" or "再也不用担心拆家了！")
	end
return false
end

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
end

local function valuecheck(inst)
    local level = inst.components.windyknifestatus.level
    local amount = math.floor(level/5)
    inst.components.weapon:SetDamage(34+amount)

    if inst.components.windyknifestatus.level >= 330 and TUNING.wklimit
	then
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
        if inst.components.windyknifestatus.level < 330 then
            inst.components.windyknifestatus:DoDeltaLevel(item.components.stackable.stacksize)
        end
    else
        inst.components.windyknifestatus:DoDeltaLevel(item.components.stackable.stacksize)
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
    valuecheck(inst)
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
	inst:AddTag("allow_action_on_impassable")	--1
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("windyknifestatus")
	
	--工具切换
	inst:AddTag("toool")
	inst:AddComponent("useableitem")
	inst.components.useableitem:SetOnUseFn(onuse)
	inst:AddComponent("named")
	inst:AddComponent("fishingrod")
	inst.components.fishingrod:SetWaitTimes(3, 10)
	inst.components.fishingrod:SetStrainTimes(30, 60)
	
	inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/windyknife.xml"

	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven

    inst:DoTaskInTime(0, function() valuecheck(inst) end)
    
    return inst
end


return Prefab( "windyknife", fn, assets, prefabs) 