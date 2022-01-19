local assets =
{
    Asset("ANIM", "anim/candybag.zip"),
    Asset("ANIM", "anim/hems_lxkd.zip"),
    Asset("IMAGE","images/inventoryimages/hems_lxkd.tex"),
    Asset("ATLAS","images/inventoryimages/hems_lxkd.xml"),
    Asset("ANIM", "anim/ui_krampusbag_2x8.zip"),
}

local prefabs =
{
}

local function onuse(inst,doer)
    if doer and TheWorld and TheWorld.components.hems_container then
        TheWorld.components.hems_container:OpenChester(doer)
    end
    return true
end
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("hems_lxkd")
    inst.AnimState:SetBuild("hems_lxkd")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryFloatable(inst, "med", 0.125, 0.65)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/hems_lxkd.xml"

    inst:AddComponent("hems_use_inventory")
    inst.components.hems_use_inventory.onusefn = onuse

    return inst
end

local function OnUpdate(self,dt)
    if self.opencount == 0 then
        self.inst:StopUpdatingComponent(self)
    else
        --for opener, _ in pairs(self.openlist) do
        --    if not opener:IsValid() then
        --        self:Close()
        --    end
        --end
    end
end

local function onopen(inst)
    -- body
end

local function onclose(inst)
    -- body
end

local function containerfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst:AddTag("nocool")
    inst:AddTag("NOBLOCK")   
    inst:AddTag("NOCLICK")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	inst:AddComponent("container")
	inst.components.container:WidgetSetup("hems_lxkd_container")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    inst.components.container.OnUpdate = OnUpdate

	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(2)

	return inst
end

return Prefab("hems_lxkd", fn, assets, prefabs),
Prefab("hems_lxkd_container", containerfn)
