local containers = require("containers")
local params = containers.params

local assets=
{
	Asset("ANIM", "anim/portablebag.zip"),
    Asset("IMAGE", "images/portablebag.tex"),
    Asset("ATLAS", "images/portablebag.xml"),
    Asset("ATLAS_BUILD", "images/portablebag.xml", 256),
}

params.portablebag =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(300, -70, 0)
    },
    type = "portablebag",
    openlimit = 1,
    itemtestfn = function(inst, item, slot)
        return not item:HasTag("portablebag") and not item:HasTag("irreplaceable")
    end
}

for y = 0, 6 do
    table.insert(params.portablebag.widget.slotpos, Vector3(-162, -75 * y + 240, 0))
    table.insert(params.portablebag.widget.slotpos, Vector3(-162 + 75, -75 * y + 240, 0))
end

local function OnOpen(inst)
    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/wilson/backpack_open")
end

local function OnClose(inst)
    TheFocalPoint.SoundEmitter:PlaySound("dontstarve/wilson/backpack_close")
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	inst.entity:AddPhysics()
    MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst)

    inst.AnimState:SetBank("portablebag")
    inst.AnimState:SetBuild("portablebag")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("portablebag")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("portablebag")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/portablebag.xml"

    return inst
end

return Prefab("portablebag", fn, assets)
