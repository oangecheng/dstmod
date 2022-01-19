local assets =
{
    Asset("ANIM", "anim/xinhua_dictionary.zip"),
	Asset("ATLAS", "images/xinhua_dictionary.xml"),
	Asset("ATLAS_BUILD", "images/xinhua_dictionary.xml",256),
}

--装备新华字典
local function onequip_dictionary(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	AddMedalComponent(owner,"reader")--添加读者组件
	--小鱼人正常读书
	if owner:HasTag("aspiring_bookworm") then
		owner:RemoveTag("aspiring_bookworm")
		owner.temporary_nomalreader=true--临时正常读者
	end
	--监听玩家读书
	inst.getmedal=function(reader,data)
		--临时读者读完书空san要扣血
		if reader and data and data.istemporary and reader.components.sanity  then
			local nowsanity=reader.components.sanity:GetPercent()
			if nowsanity<=0 then
				reader.components.health:DoDelta(TUNING_MEDAL.XINHUA_DICTIONARY_HEALTH_LOSE)
			end
		end
		if inst.components.finiteuses then
			inst.components.finiteuses:Use(1)
		end
	end
	owner:ListenForEvent("readbook", inst.getmedal)
	
end

--卸下新华字典
local function onunequip_dictionary(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	RemoveMedalComponent(owner,"reader")--移除读者组件
	--小鱼人变回原来的读书方式
	if owner.temporary_nomalreader then
		owner.temporary_nomalreader=nil
		owner:AddTag("aspiring_bookworm")
	end
	owner:RemoveEventCallback("readbook", inst.getmedal)
end

--初始化
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("xinhua_dictionary")
    inst.AnimState:SetBuild("xinhua_dictionary")
    inst.AnimState:PlayAnimation("xinhua_dictionary")
	
	inst:AddTag("xinhua_dictionary")
	
    inst.foleysound = "dontstarve/movement/foley/jewlery"

    MakeInventoryFloatable(inst, "med", nil, 0.75)
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("equippable")
    -- inst.components.equippable.equipslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "xinhua_dictionary"
	inst.components.inventoryitem.atlasname = "images/xinhua_dictionary.xml"
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.BOOK_MAXUSES.DICTIONARY)
    inst.components.finiteuses:SetUses(TUNING_MEDAL.BOOK_MAXUSES.DICTIONARY)
	
	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL
	
	inst.components.equippable:SetOnEquip(onequip_dictionary)
    inst.components.equippable:SetOnUnequip(onunequip_dictionary)
	
	MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("xinhua_dictionary", fn, assets)
