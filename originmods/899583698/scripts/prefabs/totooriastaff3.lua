local assets=
{
	Asset("ANIM", "anim/totooriastaff.zip"),
	Asset("ANIM", "anim/swap_totooriastaff.zip"),
	Asset("ATLAS", "images/inventoryimages/totooriastaff3.xml"),
}

local prefabs = {
}

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
    owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff", "swap_totooriastaff")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    rangechange(inst)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function onattack(inst, attacker, target, skipsanity)
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
	inst.entity:AddNetwork() 
	
    anim:SetBank("totooriastaff")
    anim:SetBuild("totooriastaff")
    anim:PlayAnimation("idle")
	
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
	
	inst:AddComponent("weapon")

    if TUNING.TTRMODE == false then
        inst.components.weapon:SetDamage(42)
    else
        inst.components.weapon:SetDamage(TUNING.MINIFAN_DAMAGE)
    end

	inst.components.weapon:SetRange(8, 10)
	inst.components.weapon:SetProjectile("ice_projectile")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff3.xml"
	
    inst:DoTaskInTime(0.2, function() rangechange(inst) end)

	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    --inst.components.equippable.dapperness = TUNING.CRAZINESS_MED /4

    return inst
end

return Prefab( "common/inventory/totooriastaff3", fn, assets, prefabs) 
