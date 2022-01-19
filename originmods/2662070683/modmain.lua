GLOBAL.setmetatable(
    env,
    {
        __index = function(t, k)
            return GLOBAL.rawget(GLOBAL, k)
        end
    }
)

PrefabFiles = {
    "blackdragon_sword",
}

AddMinimapAtlas("images/minimap/blackdragon_sword.xml")

AddStategraphPostInit("wilson", function(sg)
    local old_onenter = sg.states["attack"].onenter
    sg.states["attack"].onenter = function(inst,...) 
        local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
        local isriding = inst.replica.rider:IsRiding()
        if not isriding and (weapon and weapon:HasTag("blackdragon_sword")) then
            weapon:ChangeWeaponType("chu")
        end
        old_onenter(inst,...) 
    end
end)

AddPrefabPostInit("walrus_tusk",function(inst)
    if  TheWorld.ismastersim then
        if not inst.components.tradable then
            inst:AddComponent("tradable")
        end
    end
end)

STRINGS.NAMES.BLACKDRAGON_SWORD = "黑龙"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BLACKDRAGON_SWORD = "一把被封印的刀"
STRINGS.RECIPE_DESC.BLACKDRAGON_SWORD = "桀桀桀桀......"

AddRecipe("blackdragon_sword", {Ingredient("flint", 10), Ingredient("rope", 1), Ingredient("charcoal", 10)}, RECIPETABS.WAR, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil, "images/inventoryimages/blackdragon_sword.xml", "blackdragon_sword.tex")


local blackdragon_sword_button = require("widgets/blackdragon_sword_button")
local function Addui(self) 
	if self.owner  then
        self.blackdragon_sword_button = self:AddChild(blackdragon_sword_button(self.owner))	
    end
end
AddClassPostConstruct("widgets/controls", Addui)

local function rpc(inst)
    if inst:HasTag("playerghost") then 
        return 
    end
    local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    if weapon and weapon:HasTag("blackdragon_sword") then
        weapon:ChangeWeaponType("ru")
    end
end
AddModRPCHandler("blackdragon_sword", "blackdragon_sword", rpc)