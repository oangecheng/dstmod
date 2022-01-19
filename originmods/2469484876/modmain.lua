GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

PrefabFiles = {
	"hems_lxkd", 
}

Assets = {	
}

STRINGS.NAMES.HEMS_LXKD = "赫尔墨斯的旅行口袋"
STRINGS.RECIPE_DESC.HEMS_LXKD = "神的信使，神的效率"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.HEMS_LXKD = "天上地下，瞬间到达"

local function open(inst)
    if inst and TheWorld and TheWorld.components.hems_container then
        --print(inst,TheWorld.components.hems_container.chester)
        --TheWorld.components.hems_container.chester.Transform:SetPosition(inst.Transform:GetWorldPosition())
        TheWorld.components.hems_container:OpenChester(inst)
    end
end
AddModRPCHandler("hems_container", "hems", open)

local containers = require "containers"
local params = containers.params

params.hems_lxkd_container =
{
    widget =
    {
        slotpos =
        {
            Vector3(-37.5, 32 +4, 0), 
            Vector3(37.5, 32 +4, 0),
            Vector3(-37.5, -(32 +4), 0), 
            Vector3(37.5, -(32 +4), 0),
        },
        animbank = "ui_bundle_2x2",
        animbuild = "ui_bundle_2x2",
        pos = Vector3(0, 200, 0),
        side_align_tip = 120,
        buttoninfo =
         {
            text = "关闭",
            position = Vector3(0, -100, 0),
        }
    },
}

function params.hems_lxkd_container.itemtestfn(container, item, slot)
    return  not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end
function params.hems_lxkd_container.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        open(doer)
    elseif inst.replica.container ~= nil  then
        SendModRPCToServer(MOD_RPC["hems_container"]["hems"])
    end
end


AddPrefabPostInit("world",function(inst)
    if TheWorld.ismastersim then
        inst:AddComponent("hems_container")
    end
end)

local  HEMS_USE_INVENTORY = Action({ priority=1})
HEMS_USE_INVENTORY.id = "HEMS_USE_INVENTORY"
HEMS_USE_INVENTORY.str = STRINGS.ACTIONS.USEITEM
HEMS_USE_INVENTORY.fn = function(act)
    if act.doer and act.invobject and act.invobject.components.hems_use_inventory  then
        return act.invobject.components.hems_use_inventory:OnUse(act.doer)
    end
end
AddAction(HEMS_USE_INVENTORY)

AddComponentAction("INVENTORY", "hems_use_inventory" , function(inst, doer, actions)
    if doer and inst:HasTag("canuseininv_hems") then
        table.insert(actions, ACTIONS.HEMS_USE_INVENTORY)
    end
end)

AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.HEMS_USE_INVENTORY,
    function(inst, action)
		return "give"
    end))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.HEMS_USE_INVENTORY,
function(inst, action)
    return "give"
end))
    

AddRecipe("hems_lxkd",
{Ingredient("silk", 20),Ingredient("shroom_skin", 1),Ingredient("malbatross_feathered_weave", 1)},
RECIPETABS.MAGIC,  TECH.SCIENCE_ONE,
nil, nil, nil, nil, nil,
"images/inventoryimages1.xml",
"candybag.tex")
