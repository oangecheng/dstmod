local ttrstrs=STRINGS.TTRSTRINGS

local assets=
{
	Asset("ANIM", "anim/totooriastaff5green.zip"),
	Asset("ANIM", "anim/swap_totooriastaff5green.zip"),
	Asset("ATLAS", "images/inventoryimages/totooriastaff5green.xml"),
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
    owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff5green", "swap_totooriastaff5green")
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


local function prefabcheck(target)
    if target.prefab ~= "philosopherstone"
    and target.prefab ~= "redcherry" then
        return true
    else
        return false
    end
end

local function destroystructure(staff, target)
    if not staff or not target then return end
	if target.components.inventoryitem then

    	local loot1 = SpawnPrefab(target.prefab)
        TheSim:ReskinEntity( loot1.GUID, loot1.skinname, target.skinname, nil, staff.parent.userid )

    	local pt1 = Point(target.Transform:GetWorldPosition())   
    	loot1.Transform:SetPosition(pt1.x,pt1.y,pt1.z)
    	local angle1 = math.random()*2*PI
	    loot1.Physics:SetVel(2*math.cos(angle1), 10, 2*math.sin(angle1))

        local soundprefab = SpawnPrefab("ttrsoundprefab")
        soundprefab.Transform:SetPosition(pt1.x,pt1.y,pt1.z)
        soundprefab:Hide()
        soundprefab.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/chain_foley")
        soundprefab.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/bell")
        soundprefab.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
        soundprefab.SoundEmitter:PlaySound("dontstarve/common/dropGeneric")
        --soundprefab:DoTaskInTime(1, function() soundprefab:Remove() end)

    	local chance = .1
        if staff.components.inventoryitem.owner.components.totooriastatus then
            chance = .1 + staff.components.inventoryitem.owner.components.totooriastatus.xingyun/50
        end
        local loot2 = nil
        if math.random() < chance then
            soundprefab.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/lock_break")
        	loot2 = SpawnPrefab(target.prefab)
            TheSim:ReskinEntity( loot2.GUID, loot2.skinname, target.skinname, nil, staff.parent.userid )
        	local pt2 = Point(target.Transform:GetWorldPosition())   
        	loot2.Transform:SetPosition(pt2.x,pt2.y,pt2.z)
        	local angle2 = (1-math.random())*2*PI
    	    loot2.Physics:SetVel(2*math.cos(angle2), 10, 2*math.sin(angle2))
    	end

        --继承耐久
        if target.components and target.prefab ~= "windyknife" then
            if target.components.finiteuses then
                loot1.components.finiteuses:SetUses(target.components.finiteuses.current)
                if loot2 and prefabcheck(target) then
                    loot2.components.finiteuses:SetUses(target.components.finiteuses.current)
                end
            elseif target.components.fueled then
                loot1.components.fueled:SetPercent(target.components.fueled:GetPercent())
                if loot2 and prefabcheck(target) then
                    loot2.components.fueled:SetPercent(target.components.fueled:GetPercent())
                end
            elseif target.components.armor then
                loot1.components.armor:SetPercent(target.components.armor:GetPercent())
                if loot2 and prefabcheck(target) then
                    loot2.components.armor:SetPercent(target.components.armor:GetPercent())
                end
            elseif target.components.perishable then
                loot1.components.perishable:SetPercent(target.components.perishable:GetPercent())
                if loot2 and prefabcheck(target) then
                    loot2.components.perishable:SetPercent(target.components.perishable:GetPercent())
                end
            end
        end

    	staff.components.inventoryitem.owner.SoundEmitter:PlaySound("dontstarve/common/staff_dissassemble")

        local caster = staff.components.inventoryitem.owner
        local deltamod = 0
        if staff.components.inventoryitem.owner.components.totooriastatus then
            deltamod = staff.components.inventoryitem.owner.components.totooriastatus.xingyun
        end
    	if caster.components.sanity then
            caster.components.sanity:DoDelta(-100 + deltamod/20*60)
        end
    	if caster.components.health then
            caster.components.health:DoDelta(-caster.components.health.maxhealth*(.6 - deltamod/20*.2), nil, soundprefab and soundprefab.prefab or "NIL", nil, soundprefab or nil)
        end
    	if caster.components.hunger then
            caster.components.hunger:DoDelta(-50 + deltamod/20*30)
        end


        if target.components.inventory then
            target.components.inventory:DropEverything()
        end

        if target.components.container then
            target.components.container:DropEverything()
        end

        if target.components.stackable then
            --if it's stackable we only want to destroy one of them.
            target = target.components.stackable:Get()
        end

        target:Remove()
	else
	   staff.components.inventoryitem.owner.components.talker:Say(ttrstrs[35])
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork() 
	
    anim:SetBank("totooriastaff5green")
    anim:SetBuild("totooriastaff5green")
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
	--加入冰杖攻击音效2
	inst.components.weapon:SetProjectile("ice_projectile")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
	
	inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canusefrominventory = true
	inst.components.spellcaster.canonlyuseonrecipes = true
    inst.components.spellcaster:SetSpellFn(destroystructure)
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff5green.xml"
	
    inst:DoTaskInTime(0.2, function() rangechange(inst) end)

	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	--加速
	inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
	--inst.components.equippable.dapperness = TUNING.CRAZINESS_MED /4*3
    
    return inst
end


return Prefab( "common/inventory/totooriastaff5green", fn, assets, prefabs) 
