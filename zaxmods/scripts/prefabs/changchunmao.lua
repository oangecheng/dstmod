
local assets=
{
	Asset("ANIM", "anim/changchunmao.zip"), 
	Asset("IMAGE", "images/inventoryimages/changchunmao.tex"), 
	Asset("ATLAS", "images/inventoryimages/changchunmao.xml"),
}


local function onequiphat(inst, owner) --装备的函数
    owner.AnimState:OverrideSymbol("swap_hat", "changchunmao", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
    if owner:HasTag("player") then --隐藏head  显示head——hat
            owner.AnimState:Hide("HEAD")
            owner.AnimState:Show("HEAD_HAT")
    end
        if inst.components.fueled ~= nil then --如果有耐久 那么开始掉
            inst.components.fueled:StartConsuming()
        end
end

local function onunequiphat(inst, owner) --解除帽子
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")
        if owner:HasTag("player") then
            owner.AnimState:Show("HEAD")
            owner.AnimState:Hide("HEAD_HAT")
        end

        if inst.components.fueled ~= nil then --停止掉耐久
            inst.components.fueled:StopConsuming()
        end
end

local function opentop_onequip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_hat", "changchunmao", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
		if inst.components.fueled ~= nil then
            inst.components.fueled:StartConsuming()
        end
       
end


local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab == "walrushat" then
        return true
    elseif item.prefab == "silk" then
        return true
    elseif item.prefab == "pigskin" then
        return true
    end
    return false
end

local function OnGemGiven(inst, giver, item)

    -- 使用海象帽升级精神恢复，每个海象帽只能 +1 精神恢复
    -- 数值2是帽子初始属性，精神 +6
    if item.prefab == "walrushat" then
        local dapperness = inst.components.zaxhatstatus.dapperness
        inst.components.zaxhatstatus.dapperness = dapperness + 1
        inst.components.equippable.dapperness = (((dapperness + 1) / 3) + 2) * TUNING.DAPPERNESS_MED
        inst.components.fueled.currentfuel = inst.components.fueled.maxfuel
    end
    
    -- 使用蜘蛛网升级保暖
    -- 每个蜘蛛网 +1 保暖
    if item.prefab == "silk" then
        local insulator = inst.components.zaxhatstatus.insulator
        inst.components.zaxhatstatus.insulator = insulator + 1
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED + insulator + 1)
    end

    -- 使用猪皮升级防水
    -- 每个猪皮 +1% 的防水
    if item.prefab == "pigskin" then
        local waterproofer = inst.components.zaxhatstatus.waterproofer
        inst.components.zaxhatstatus.waterproofer = waterproofer + 1
        inst.components.waterproofer:SetEffectiveness(.2 + ((waterproofer + 1) / 100))
    end

    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")
end


local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("changchunmao")  
    inst.AnimState:SetBuild("changchunmao")
    inst.AnimState:PlayAnimation("anim")

	inst:AddTag("hat")
    	

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable") 
    inst:AddComponent("zaxhatstatus")
		
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/changchunmao.xml"
	inst:AddComponent("equippable") 
	inst.components.equippable.equipslot = EQUIPSLOTS.HEAD 
	inst.components.equippable:SetOnEquip( onequiphat ) 
	inst.components.equippable:SetOnUnequip( onunequiphat ) 


	--inst:AddComponent("insulator") 
	--inst.components.insulator:SetInsulation(120)
	--inst.components.equippable.dapperness = TUNING.DAPPERNESS_LARGE  
 	--inst.components.equippable:SetOnEquip(opentop_onequip)


     -- 添加保暖组件
    inst:AddComponent("insulator")
    inst:AddComponent("waterproofer")  


    -- 添加给予组件
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.onaccept = OnGemGiven


	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = FUELTYPE.USAGE
	inst.components.fueled:InitializeFuelLevel(TUNING.WALRUSHAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(inst.Remove)

       -- 初始化帽子属性
    -- 精神恢复/保暖/防水
    inst:DoTaskInTime(.2, function()
        inst.components.equippable.dapperness = ((inst.components.zaxhatstatus.dapperness / 3) + 2) * TUNING.DAPPERNESS_MED
        inst.components.insulator:SetInsulation(TUNING.INSULATION_MED + inst.components.zaxhatstatus.insulator)
        inst.components.waterproofer:SetEffectiveness(.2 + (inst.components.zaxhatstatus.waterproofer / 100))
    end)
	
	MakeHauntableLaunchAndPerish(inst) 
    return inst
end 
    
return Prefab( "changchunmao", fn, assets) 