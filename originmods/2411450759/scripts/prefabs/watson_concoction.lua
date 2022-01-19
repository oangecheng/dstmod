local ConcHeal = require "modifications/watson_concoction_heal"

local assets =
{
    Asset("ANIM", "anim/watson_concoction.zip"),

    Asset("ATLAS", "images/inventoryimages/watson_concoction.xml"),
    Asset("IMAGE", "images/inventoryimages/watson_concoction.tex"),

    Asset("INV_IMAGE", "watson_concoction"),
}

local function InjectConcoction(inst, user)
    if user.components.debuffable ~= nil and user.components.debuffable:IsEnabled() and
        not (user.components.health ~= nil and user.components.health:IsDead()) and
        not user:HasTag("playerghost") then
            user.components.debuffable:AddDebuff("buff_watsonconcoctioneffect", "buff_watsonconcoctioneffect")
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("watson_concoction_ent")
    inst.AnimState:SetBuild("watson_concoction")
    inst.AnimState:PlayAnimation("watson_concoction_anim")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()


    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("healer")
    inst.components.healer:SetHealthAmount(0) 
    inst.components.healer.onhealfn = InjectConcoction
    inst.components.healer.Heal = ConcHeal

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "watson_concoction"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/watson_concoction.xml"

    MakeHauntableLaunch(inst)

    return inst
end
return Prefab("watson_concoction", fn, assets)