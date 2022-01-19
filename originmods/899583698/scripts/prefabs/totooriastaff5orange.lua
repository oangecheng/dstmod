local assets=
{
	Asset("ANIM", "anim/totooriastaff5orange.zip"),
	Asset("ANIM", "anim/swap_totooriastaff5orange.zip"),
	Asset("ATLAS", "images/inventoryimages/totooriastaff5orange.xml"),
}

local prefabs = {
    "sand_puff_large_front",
    "sand_puff_large_back",
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
    owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff5orange", "swap_totooriastaff5orange")
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
        if attacker.components.totooriastatus then
            target.components.freezable:AddColdness(1+attacker.components.totooriastatus.dengji/20)
        else
            target.components.freezable:AddColdness(1)
        end
        target.components.freezable:SpawnShatterFX()
    end

    --攻击减防御
    if not target.components.combat
    or not attacker.components.combat then
        return
    end

    local buffvalue = 1/100
    local timeleft = 5
    local add = buffvalue*(attacker.components.totooriastatus and 2 or 1)

    target.ttrpdpnum = 100
    if not target.isttrpdp then
        target.isttrpdp = true
        target.components.combat.old_extdamage = target.components.combat.externaldamagetakenmultipliers._modifier
        target.ttrpdpperi = target:DoPeriodicTask(1, function()
            if not target then return end
            target.ttrpdpnum = target.ttrpdpnum - 100/timeleft
            if target.ttrpdpnum <= 0 then
                target.components.combat.externaldamagetakenmultipliers._modifier = target.components.combat.old_extdamage
                target.isttrpdp = nil
                target.ttrpdpnum = nil
                target.ttrpdpperi:Cancel()
            end
        end)
    end
    local old_extakendmg = target.components.combat.externaldamagetakenmultipliers._modifier
    target.components.combat.externaldamagetakenmultipliers._modifier = old_extakendmg + add
end

local function onblink(staff, pos, caster)--瞬移耗脑
    if caster.components.sanity ~= nil then
        caster.components.sanity:DoDelta(-TUNING.SANITY_MED)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork() 
	
    anim:SetBank("totooriastaff5orange")
    anim:SetBuild("totooriastaff5orange")
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
        inst.components.weapon:SetDamage(60)
    else
        inst.components.weapon:SetDamage(TUNING.MINIFAN_DAMAGE)
    end

	inst.components.weapon:SetRange(8, 10)
	inst.components.weapon:SetProjectile("ice_projectile")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
	
	inst:AddComponent("blinkstaff")--瞬移杖效果
    inst.components.blinkstaff:SetFX("sand_puff_large_front", "sand_puff_large_back")
	inst.components.blinkstaff.onblinkfn = onblink
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff5orange.xml"
	
    inst:DoTaskInTime(0.2, function() rangechange(inst) end)

	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	--加速
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	--inst.components.equippable.dapperness = TUNING.CRAZINESS_MED /4*3
    
    return inst
end


return Prefab( "common/inventory/totooriastaff5orange", fn, assets, prefabs) 
