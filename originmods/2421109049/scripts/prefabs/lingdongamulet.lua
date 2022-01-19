local assets =
{
    Asset("ANIM", "anim/lingdongamulet.zip"),
	Asset("ANIM", "anim/torso_lingdong.zip"),
	Asset("ATLAS", "images/inventoryimages/lingdongamulet.xml"),
	Asset("IMAGE", "images/inventoryimages/lingdongamulet.tex"),
}

local prefabs = {	}

local function onequip(inst, owner)
    --owner.AnimState:OverrideSymbol("swap_body", "torso_lingdong", "purpleamulet")	
	owner.components.temperature:SetTemp(20)		--恒温
    owner:PushEvent("stopfreezing")
    owner:PushEvent("stopoverheating")
end

local function onunequip(inst, owner)
    --owner.AnimState:ClearOverrideSymbol("swap_body")
	owner.components.temperature:SetTemp(nil)		--温度
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("amulets")
    inst.AnimState:SetBuild("lingdongamulet")
    inst.AnimState:PlayAnimation("blueamulet")
	
    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "lingdongamulet"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/lingdongamulet.xml"
	
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
	--inst.components.equippable.walkspeedmult = 1.1
	inst.components.equippable:SetOnEquip( onequip )
	inst.components.equippable:SetOnUnequip( onunequip )

	MakeHauntableLaunch(inst)
	
	inst:AddComponent("hauntable")				--闹鬼
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)		--闹鬼复活
	
	inst:AddComponent("blinkstaff")				--传送

	return inst
end

return Prefab( "lingdongamulet", fn, assets, prefabs)