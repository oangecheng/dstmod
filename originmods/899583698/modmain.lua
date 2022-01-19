local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH
local cooking = require("cooking")

local LAN_ = GetModConfigData('Language')
GLOBAL.TUNING.TOTOORIA = {}
if LAN_ then
require 'strings_ttr_c'
TUNING.ttrlan = true
else
require 'strings_ttr_e'
TUNING.ttrlan = false
end
local uistrs = STRINGS.TTRUI

--选人信息
TUNING.TOTOORIA_HEALTH = 75
TUNING.TOTOORIA_HUNGER = 150
TUNING.TOTOORIA_SANITY = 200
STRINGS.CHARACTER_SURVIVABILITY.totooria = STRINGS.TTRSTRINGS[52]
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.TOTOORIA = {"totooriastaff1", "totooriahat", "goldnugget",}
local c_startitem = {
	totooriastaff1 = {
		atlas = "images/inventoryimages/totooriastaff1.xml",
		image = "totooriastaff1.tex",
	},
	totooriahat = {
		atlas = "images/inventoryimages/totooriahat.xml",
		image = "totooriahat.tex",
	},
	goldnugget = {
		atlas = "images/inventoryimages.xml",
		image = "goldnugget.tex",
	},
}
for k,v in pairs(c_startitem) do
	TUNING.STARTING_ITEM_IMAGE_OVERRIDE[k] = v
end

modimport("totooria_util/totooria_util.lua")

PrefabFiles = {
	"totooria",
	"totooriastaff1",
	"totooriastaff2",
	"totooriastaff3",
	"totooriastaff4",
	"totooriastaff5green",
	"totooriastaff5orange",
	"totooriastaff5yellow",
	"tbooks",
	"totooriahat",
	"philosopherstone",
	"ttrsoundprefab",
	"tportablespicer",
	"tportableblender",
    }

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/totooria.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/totooria.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/totooria.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/totooria.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/totooria_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/totooria_silho.xml" ),
	
	Asset( "IMAGE", "images/names_totooria.tex" ),
    Asset( "ATLAS", "images/names_totooria.xml" ),

    Asset( "IMAGE", "bigportraits/totooria.tex" ),
    Asset( "ATLAS", "bigportraits/totooria.xml" ),
	
	Asset( "IMAGE", "images/map_icons/totooria.tex" ),
	Asset( "ATLAS", "images/map_icons/totooria.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_totooria.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_totooria.xml" ),

	Asset( "IMAGE", "images/avatars/avatar_ghost_totooria.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_totooria.xml" ),

	Asset( "IMAGE", "images/avatars/self_inspect_totooria.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_totooria.xml" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff1.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff1.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff2.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff2.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff3.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff3.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff4.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff4.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff5green.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff5green.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff5orange.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff5orange.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/totooriastaff5yellow.xml"),
	Asset( "IMAGE", "images/inventoryimages/totooriastaff5yellow.tex" ),
	
	Asset( "ATLAS", "images/hud/totooriatab.xml"),
	Asset( "IMAGE", "images/hud/totooriatab.tex" ),

	Asset( "ATLAS", "images/hud/background.xml"),
	Asset( "IMAGE", "images/hud/background.tex" ),

	Asset( "ATLAS", "images/hud/background_small.xml"),
	Asset( "IMAGE", "images/hud/background_small.tex" ),

	Asset( "ATLAS", "images/hud/explain_ch.xml"),
	Asset( "IMAGE", "images/hud/explain_ch.tex" ),

	Asset( "ATLAS", "images/hud/explain_en.xml"),
	Asset( "IMAGE", "images/hud/explain_en.tex" ),

	Asset( "ATLAS", "images/hud/skillpoint_ch.xml"),
	Asset( "IMAGE", "images/hud/skillpoint_ch.tex" ),

	Asset( "ATLAS", "images/hud/skillpoint_en.xml"),
	Asset( "IMAGE", "images/hud/skillpoint_en.tex" ),

	Asset( "ATLAS", "images/hud/specialskill_ch.xml"),
	Asset( "IMAGE", "images/hud/specialskill_ch.tex" ),

	Asset( "ATLAS", "images/hud/specialskill_en.xml"),
	Asset( "IMAGE", "images/hud/specialskill_en.tex" ),

	Asset( "ATLAS", "images/hud/left.xml"),
	Asset( "IMAGE", "images/hud/left.tex"),

	Asset( "ATLAS", "images/hud/right.xml"),
	Asset( "IMAGE", "images/hud/right.tex"),

	Asset( "ATLAS", "images/hud/up.xml"),
	Asset( "IMAGE", "images/hud/up.tex"),

	Asset( "ATLAS", "images/hud/down.xml"),
	Asset( "IMAGE", "images/hud/down.tex"),

	Asset( "ATLAS", "images/hud/youshan.xml"),
	Asset( "IMAGE", "images/hud/youshan.tex" ),

	Asset( "ATLAS", "images/hud/youshanoff.xml"),
	Asset( "IMAGE", "images/hud/youshanoff.tex" ),

	Asset( "ATLAS", "images/hud/dachu.xml"),
	Asset( "IMAGE", "images/hud/dachu.tex" ),

	Asset( "ATLAS", "images/hud/dachuoff.xml"),
	Asset( "IMAGE", "images/hud/dachuoff.tex" ),

	Asset( "ATLAS", "images/hud/qiaoshou.xml"),
	Asset( "IMAGE", "images/hud/qiaoshou.tex" ),

	Asset( "ATLAS", "images/hud/qiaoshouoff.xml"),
	Asset( "IMAGE", "images/hud/qiaoshouoff.tex" ),

	Asset( "ATLAS", "images/hud/xuezhe.xml"),
	Asset( "IMAGE", "images/hud/xuezhe.tex" ),

	Asset( "ATLAS", "images/hud/xuezheoff.xml"),
	Asset( "IMAGE", "images/hud/xuezheoff.tex" ),

	Asset( "ATLAS", "images/hud/shixue.xml"),
	Asset( "IMAGE", "images/hud/shixue.tex"),

	Asset( "ATLAS", "images/hud/shixue_none.xml"),
	Asset( "IMAGE", "images/hud/shixue_none.tex"),

	Asset( "ATLAS", "images/hud/yonggan.xml"),
	Asset( "IMAGE", "images/hud/yonggan.tex"),

	Asset( "ATLAS", "images/hud/yonggan_none.xml"),
	Asset( "IMAGE", "images/hud/yonggan_none.tex"),

	Asset( "ATLAS", "images/hud/lingqiao.xml"),
	Asset( "IMAGE", "images/hud/lingqiao.tex"),

	Asset( "ATLAS", "images/hud/lingqiao_none.xml"),
	Asset( "IMAGE", "images/hud/lingqiao_none.tex"),

	Asset( "ATLAS", "images/hud/point.xml"),
	Asset( "IMAGE", "images/hud/point.tex"),

	Asset( "ATLAS", "images/hud/pointbg.xml"),
	Asset( "IMAGE", "images/hud/pointbg.tex"),

	Asset( "ATLAS", "images/hud/lv/0.xml"),
	Asset( "IMAGE", "images/hud/lv/0.tex"),

	Asset( "ATLAS", "images/hud/lv/1.xml"),
	Asset( "IMAGE", "images/hud/lv/1.tex"),

	Asset( "ATLAS", "images/hud/lv/2.xml"),
	Asset( "IMAGE", "images/hud/lv/2.tex"),

	Asset( "ATLAS", "images/hud/lv/3.xml"),
	Asset( "IMAGE", "images/hud/lv/3.tex"),

	Asset( "ATLAS", "images/hud/lv/4.xml"),
	Asset( "IMAGE", "images/hud/lv/4.tex"),

	Asset( "ATLAS", "images/hud/lv/5.xml"),
	Asset( "IMAGE", "images/hud/lv/5.tex"),

	Asset( "ATLAS", "images/hud/lv/6.xml"),
	Asset( "IMAGE", "images/hud/lv/6.tex"),

	Asset( "ATLAS", "images/hud/lv/7.xml"),
	Asset( "IMAGE", "images/hud/lv/7.tex"),

	Asset( "ATLAS", "images/hud/lv/8.xml"),
	Asset( "IMAGE", "images/hud/lv/8.tex"),

	Asset( "ATLAS", "images/hud/lv/9.xml"),
	Asset( "IMAGE", "images/hud/lv/9.tex"),

	Asset( "ATLAS", "images/hud/lv/10.xml"),
	Asset( "IMAGE", "images/hud/lv/10.tex"),

	Asset( "ATLAS", "images/hud/lv/11.xml"),
	Asset( "IMAGE", "images/hud/lv/11.tex"),

	Asset( "ATLAS", "images/hud/lv/12.xml"),
	Asset( "IMAGE", "images/hud/lv/12.tex"),

	Asset( "ATLAS", "images/hud/lv/13.xml"),
	Asset( "IMAGE", "images/hud/lv/13.tex"),

	Asset( "ATLAS", "images/hud/lv/14.xml"),
	Asset( "IMAGE", "images/hud/lv/14.tex"),

	Asset( "ATLAS", "images/hud/lv/15.xml"),
	Asset( "IMAGE", "images/hud/lv/15.tex"),

	Asset( "ATLAS", "images/hud/lv/16.xml"),
	Asset( "IMAGE", "images/hud/lv/16.tex"),

	Asset( "ATLAS", "images/hud/lv/17.xml"),
	Asset( "IMAGE", "images/hud/lv/17.tex"),

	Asset( "ATLAS", "images/hud/lv/18.xml"),
	Asset( "IMAGE", "images/hud/lv/18.tex"),

	Asset( "ATLAS", "images/hud/lv/19.xml"),
	Asset( "IMAGE", "images/hud/lv/19.tex"),

	Asset( "ATLAS", "images/hud/lv/20.xml"),
	Asset( "IMAGE", "images/hud/lv/20.tex"),

	Asset("ANIM", "anim/ttrexp.zip"),

	Asset("ATLAS", "images/inventoryimages/totooriaglasses.xml"),

	Asset("ATLAS", "images/inventoryimages/philosopherstone.xml"),

	Asset("ATLAS", "images/inventoryimages/totooriahat.xml"),
}

local totooriatab = AddRecipeTab(STRINGS.TOTOORIATAB, 999, "images/hud/totooriatab.xml", "totooriatab.tex", "totooria_builder")

AddRecipe("totooriastaff1", {GLOBAL.Ingredient("twigs", 4), GLOBAL.Ingredient("goldnugget", 2), GLOBAL.Ingredient("redgem", 1)}, 
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriastaff1.xml", "totooriastaff1.tex" )

AddRecipe("totooriastaff2", {GLOBAL.Ingredient("totooriastaff1", 1, "images/inventoryimages/totooriastaff1.xml"), GLOBAL.Ingredient("goldnugget", 6), GLOBAL.Ingredient("flint", 6)}, 
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriastaff2.xml", "totooriastaff2.tex" )

AddRecipe("totooriastaff3", {GLOBAL.Ingredient("totooriastaff2", 1, "images/inventoryimages/totooriastaff2.xml"), GLOBAL.Ingredient("goldnugget", 6), GLOBAL.Ingredient("icestaff", 1)}, 
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriastaff3.xml", "totooriastaff3.tex" )

AddRecipe("totooriastaff4", {GLOBAL.Ingredient("totooriastaff3", 1, "images/inventoryimages/totooriastaff3.xml"), GLOBAL.Ingredient("goldnugget", 4), GLOBAL.Ingredient("cane", 1)}, 
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriastaff4.xml", "totooriastaff4.tex" )

AddRecipe("totooriastaff5green", {GLOBAL.Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"), GLOBAL.Ingredient("greenstaff", 1), GLOBAL.Ingredient("icecream", 2)}, 
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriastaff5green.xml", "totooriastaff5green.tex" )

AddRecipe("totooriastaff5orange", {GLOBAL.Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"), GLOBAL.Ingredient("orangestaff", 1), GLOBAL.Ingredient("gears", 2)}, 
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriastaff5orange.xml", "totooriastaff5orange.tex" )

if GetModConfigData('GameMode') == true then
	AddRecipe("totooriastaff5yellow", {GLOBAL.Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"), GLOBAL.Ingredient("yellowstaff", 1), GLOBAL.Ingredient("lightflier", 4)}, 
	totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
	"images/inventoryimages/totooriastaff5yellow.xml", "totooriastaff5yellow.tex" )
else
	AddRecipe("totooriastaff5yellow", {GLOBAL.Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"), GLOBAL.Ingredient("yellowstaff", 1), GLOBAL.Ingredient("lightbulb", 6)}, 
	totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder", 
	"images/inventoryimages/totooriastaff5yellow.xml", "totooriastaff5yellow.tex" )
end

--AddRecipe("totooriaglasses", {GLOBAL.Ingredient("marble", 1), GLOBAL.Ingredient("nightmarefuel", 2), GLOBAL.Ingredient("feather_crow", 1)}, 
--totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder", 
--"images/inventoryimages/totooriaglasses.xml", "totooriaglasses.tex" )

AddRecipe("totooriahat", {GLOBAL.Ingredient("goldnugget", 2), GLOBAL.Ingredient("redgem", 1), GLOBAL.Ingredient("feather_robin_winter", 2)}, 
totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/totooriahat.xml", "totooriahat.tex" )

AddRecipe("philosopherstone", {GLOBAL.Ingredient("redgem", 2), GLOBAL.Ingredient("bluegem", 2), GLOBAL.Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 70)}, 
totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder", 
"images/inventoryimages/philosopherstone.xml", "philosopherstone.tex" )

local book_defs =
{
    --"book_gardening",
    "book_birds",
    "book_horticulture",
    "book_silviculture",
    "book_sleep",
    "book_brimstone",
    "book_tentacles",
}
for k,name in ipairs(book_defs) do
	AddRecipe(
		("t"..name), 
		GLOBAL.AllRecipes[name] and GLOBAL.AllRecipes[name].ingredients or GLOBAL.AllRecipes["book_birds"].ingredients,
		totooriatab,
		TECH.NONE,
		nil, nil, nil, nil,
		"totooria_builder", 
		(name == "book_horticulture" or name == "book_silviculture") and "images/inventoryimages1.xml" or "images/inventoryimages.xml",
		name..".tex"
	)
end

AddRecipe("tportablespicer_item", {Ingredient("goldnugget", 2), Ingredient("cutstone", 3), Ingredient("twigs", 6)},
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder",
"images/inventoryimages2.xml", "portablespicer_item.tex")
AddRecipe("tportableblender_item", {Ingredient("goldnugget", 2), Ingredient("transistor", 2), Ingredient("twigs", 4)},
totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder",
"images/inventoryimages2.xml", "portableblender_item.tex")

AddRecipe("goldnugget", {GLOBAL.Ingredient("rocks", 3), GLOBAL.Ingredient("nitre", 1)}, totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder")
AddRecipe("rocks", {GLOBAL.Ingredient("goldnugget", 1)}, totooriatab, TECH.NONE, nil, nil, nil, 4, "totooria_builder")
AddRecipe("flint", {GLOBAL.Ingredient("goldnugget", 1)}, totooriatab, TECH.NONE, nil, nil, nil, 3, "totooria_builder")
AddRecipe("nitre", {GLOBAL.Ingredient("goldnugget", 1)}, totooriatab, TECH.NONE, nil, nil, nil, 3, "totooria_builder")
AddRecipe("saltrock", {GLOBAL.Ingredient("goldnugget", 1), GLOBAL.Ingredient("spidergland", 1)}, totooriatab, TECH.NONE, nil, nil, nil, nil, "totooria_builder")
AddRecipe("lightbulb", {GLOBAL.Ingredient("nightmarefuel", 1)}, totooriatab, TECH.NONE, nil, nil, nil, 4, "totooria_builder")
AddRecipe("spoiled_food", {GLOBAL.Ingredient("ash", 8)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, 4, "totooria_builder")
AddRecipe("ice", {GLOBAL.Ingredient("goldnugget", 1), GLOBAL.Ingredient("ash", 2)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, 3, "totooria_builder")
AddRecipe("steelwool", {GLOBAL.Ingredient("trunk_summer", 2), GLOBAL.Ingredient("rope", 2)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
AddRecipe("lureplantbulb", {GLOBAL.Ingredient("papyrus", 4), GLOBAL.Ingredient("tentaclespots", 2)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
AddRecipe("mandrake", {GLOBAL.Ingredient("carrot", 8), GLOBAL.Ingredient("wetgoop", 1), GLOBAL.Ingredient("papyrus", 6)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")

AddRecipe("redgem", {GLOBAL.Ingredient("feather_robin", 4), GLOBAL.Ingredient("ice", 4), GLOBAL.Ingredient("goldnugget", 4)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
AddRecipe("bluegem", {GLOBAL.Ingredient("feather_crow", 4), GLOBAL.Ingredient("ice", 4), GLOBAL.Ingredient("goldnugget", 4)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")

if GetModConfigData('GameMode') == false then
	AddRecipe("greengem", {GLOBAL.Ingredient("feather_crow", 4), GLOBAL.Ingredient("gunpowder", 2), GLOBAL.Ingredient("durian", 1)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
	AddRecipe("orangegem", {GLOBAL.Ingredient("feather_crow", 4), GLOBAL.Ingredient("gunpowder", 2), GLOBAL.Ingredient("pumpkin", 1)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
	AddRecipe("yellowgem", {GLOBAL.Ingredient("feather_crow", 4), GLOBAL.Ingredient("gunpowder", 2), GLOBAL.Ingredient("powcake", 1)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
	AddRecipe("gears", {GLOBAL.Ingredient("flint", 4), GLOBAL.Ingredient("cutstone", 4), GLOBAL.Ingredient("goldnugget", 2)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
	--AddRecipe("livinglog", {GLOBAL.Ingredient("log", 2), GLOBAL.Ingredient("wetgoop", 1)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, nil, "totooria_builder")
	AddRecipe("thulecite_pieces", {GLOBAL.Ingredient("rocks", 2), GLOBAL.Ingredient("goldnugget", 1)}, totooriatab, TECH.SCIENCE_ONE, nil, nil, nil, 3, "totooria_builder")

	TUNING.TTRMODE = false
end

--能放置大厨厨具
local function deployportable(inst)
	if inst.components.deployable then
		local currenttag = inst.components.deployable.restrictedtag
		if not inst.components.deployable.ttrcachedtag then
			inst.components.deployable.ttrcachedtag = currenttag --记载最初tag
		end

		if inst.components.inventoryitem then
			if inst.components.inventoryitem.owner then --加载判定
				local owner = inst.components.inventoryitem.owner
				inst.components.deployable.restrictedtag = 
				owner.components.totooriastatus --在角色物品栏里(或鼠标手持)
				and "totooria_builder"
				or owner.components.inventoryitem --在角色背包里
				and owner.components.inventoryitem.owner
				and owner.components.inventoryitem.owner.components.totooriastatus
				and "totooria_builder"
				or inst.components.deployable.ttrcachedtag
			end

			local oldputinfn = inst.components.inventoryitem.onputininventoryfn
			inst.components.inventoryitem:SetOnPutInInventoryFn(function(inst, owner) --进入物品栏判定
				if owner then
					inst.components.deployable.restrictedtag = 
					owner.components.totooriastatus
					and "totooria_builder"
					or owner.components.inventoryitem
					and owner.components.inventoryitem.owner
					and owner.components.inventoryitem.owner.components.totooriastatus
					and "totooria_builder"
					or inst.components.deployable.ttrcachedtag
				end
				if oldputinfn then
					return oldputinfn(inst, owner)
				end
			end)
		end
	end
end
AddPrefabPostInit("portablespicer_item", deployportable)--原香料锅
AddPrefabPostInit("portableblender_item", deployportable)--原研磨器
AddPrefabPostInit("tportablespicer_item", deployportable)--独立香料锅
AddPrefabPostInit("tportableblender_item", deployportable)--独立研磨器

--能打开原香料锅
local oldactrumfn = GLOBAL.ACTIONS.RUMMAGE.fn
local oldactstofn = GLOBAL.ACTIONS.STORE.fn
local function actfn(act, oldfn)
	local targ = act.target or act.invobject
	if targ == nil
	or not act.doer:HasTag("totooria_builder")
	or not targ:HasTag("mastercookware")
	or targ.prefab == "portablecookpot" then
		return oldfn(act)
	end

	if targ.components.container ~= nil then
		targ:RemoveTag("mastercookware")
		if not targ.isalreadylistenttr then
			targ.isalreadylistenttr = true
			targ:ListenForEvent("onopen", function()
				if act.doer:HasTag("totooria_builder") and not targ:HasTag("mastercookware") then
					targ:AddTag("mastercookware")
				end
			end)
			targ:ListenForEvent("onclose", function()
				if act.doer:HasTag("totooria_builder") and not targ:HasTag("mastercookware") then
					targ:AddTag("mastercookware")
				end
			end)
			targ:ListenForEvent("onputininventory", function()
				if act.doer:HasTag("totooria_builder") and not targ:HasTag("mastercookware") then
					targ:AddTag("mastercookware")
				end
			end)
		end
	end
	return oldfn(act)
end
GLOBAL.ACTIONS.RUMMAGE.fn = function(act) --翻找
    return actfn(act, oldactrumfn)
end
GLOBAL.ACTIONS.STORE.fn = function(act) --放入
    return actfn(act, oldactstofn)
end

--能收回香料锅和研磨器（覆盖/破坏性修改，暂时想不到其他办法）
AddComponentAction("SCENE", "portablestructure", function(inst, doer, actions, right)
    if right and not inst:HasTag("fire") and
        (not inst:HasTag("mastercookware") or doer:HasTag("masterchef") or doer:HasTag("totooria_builder") and inst.prefab ~= "portablecookpot") then

        if  not inst.candismantle or inst.candismantle(inst) then
            local container = inst.replica.container
            if (container == nil or (container:CanBeOpened() and not container:IsOpenedBy(doer)))  then
                table.insert(actions, GLOBAL.ACTIONS.DISMANTLE)
            end
        end
    end
end)

--能对香料锅点右键"调味"（覆盖/破坏性修改，暂时想不到其他办法）
AddComponentAction("SCENE", "stewer", function(inst, doer, actions, right)
    if not inst:HasTag("burnt") and
        not (doer.replica.rider ~= nil and doer.replica.rider:IsRiding()) then
        if inst:HasTag("donecooking") then
            table.insert(actions, GLOBAL.ACTIONS.HARVEST)
        elseif right and (
            (   inst:HasTag("readytocook") and
                --(not inst:HasTag("professionalcookware") or doer:HasTag("professionalchef")) and
                (not inst:HasTag("mastercookware") or doer:HasTag("masterchef")
            	or doer:HasTag("totooria_builder") and inst.prefab ~= "portablecookpot")
            ) or
            (   inst.replica.container ~= nil and
                inst.replica.container:IsFull() and
                inst.replica.container:IsOpenedBy(doer)
            )
        ) then
            table.insert(actions, GLOBAL.ACTIONS.COOK)
        end
    end
end)

--------------------------------------------------------------------

local function PositionUI(self, screensize)
	local hudscale = self.top_root:GetScale()
	local scale = GetModConfigData('UIScale')
	local height = GetModConfigData('UIHeight')
	self.uitotooria:SetScale(scale*hudscale.x,scale*hudscale.y,1)
	self.uitotooria:SetPosition(0,height*hudscale.x,0)
end

--专属UI
local uitotooria = require("widgets/uitotooria")
local function AddUITotooria(self)
    if self.owner and self.owner:HasTag("totooria_builder") then
        self.uitotooria = self.top_root:AddChild(uitotooria(self.owner))
        local screensize = {GLOBAL.TheSim:GetScreenSize()}
        PositionUI(self, screensize)
        self.uitotooria:SetHAnchor(0)
        self.uitotooria:SetVAnchor(2)
        --H: 0=中间 1=左端 2=右端
        --V: 0=中间 1=顶端 2=底端
        --self.uitotooria:MoveToFront()
        local OnUpdate_base = self.OnUpdate
		self.OnUpdate = function(self, dt)
			OnUpdate_base(self, dt)
			local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
			if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
				PositionUI(self, curscreensize)
				screensize = curscreensize
			end
		end
    end
end
AddClassPostConstruct("widgets/controls", AddUITotooria)

--双倍收锅
AddComponentPostInit("stewer", function(self)
    local oold_harvest = self.Harvest
    function self:Harvest(harvester)
    	if not harvester or not harvester.components.totooriastatus or not harvester:HasTag("teji_dachu") then
			return oold_harvest(self, harvester)
		end

	    if self.done then
	        if self.onharvest ~= nil then
	            self.onharvest(self.inst)
	        end

	        if self.product ~= nil then
	            local loot = GLOBAL.SpawnPrefab(self.product)
	            if loot ~= nil then
					if harvester ~= nil and self.chef_id == harvester.userid then
						harvester:PushEvent("learncookbookrecipe", {product = self.product, ingredients = self.ingredient_prefabs})
					end

					local recipe = cooking.GetRecipe(self.inst.prefab, self.product)
					local stacksize = recipe and recipe.stacksize or 1
					if stacksize >= 1 and loot.components.stackable then
						loot.components.stackable:SetStackSize(stacksize*2)
					end
	            
	                if self.spoiltime ~= nil and loot.components.perishable ~= nil then
	                    local spoilpercent = self:GetTimeToSpoil() / self.spoiltime
	                    loot.components.perishable:SetPercent(self.product_spoilage * spoilpercent)
	                    loot.components.perishable:StartPerishing()
	                end
	                if harvester ~= nil and harvester.components.inventory ~= nil then
	                    harvester.components.inventory:GiveItem(loot, nil, self.inst:GetPosition())
	                else
	                    LaunchAt(loot, self.inst, nil, 1, 1)
	                end
	            end
	            self.product = nil
	        end

	        if self.task ~= nil then
	            self.task:Cancel()
	            self.task = nil
	        end
	        self.targettime = nil
	        self.done = nil
	        self.spoiltime = nil
	        self.product_spoilage = nil

	        if self.inst.components.container ~= nil then      
	            self.inst.components.container.canbeopened = true
	        end

	        return true
	    end
    end
end)

local function farmharvest(inst)
	if not inst.components.growable then return end
	local oldSetStage = inst.components.growable.SetStage
	inst.components.growable.SetStage = function(self, stage)
		oldSetStage(self, stage)
		if inst.ttrOldSpawnLootPrefabcache and inst.components.lootdropper then
			inst.components.lootdropper.SpawnLootPrefab = inst.ttrOldSpawnLootPrefabcache
			inst.ttrOldSpawnLootPrefabcache = nil
		end
		if inst.components.pickable then
			local selfpick = inst.components.pickable
			local oldpick = inst.components.pickable.Pick
			inst.components.pickable.Pick = function(selfpick, picker)
				if picker and inst.components.lootdropper and picker.components.totooriastatus and picker:HasTag("teji_qiaoshou") then
					if not inst.ttrOldSpawnLootPrefabcache then
						inst.ttrOldSpawnLootPrefabcache = inst.components.lootdropper.SpawnLootPrefab
					end
					local selflootdpr = inst.components.lootdropper
					inst.components.lootdropper.SpawnLootPrefab = function(selflootdpr, lootprefab, pt, linked_skinname, skin_id, userid)
						local loot = inst.ttrOldSpawnLootPrefabcache(selflootdpr, lootprefab, pt, linked_skinname, skin_id, userid)
						if picker and loot ~= nil then
							local num = nil
							if picker.components.totooriastatus and picker:HasTag("teji_qiaoshou") then
								num = 2
							end
							if loot.components.stackable then
								local orisize = loot.components.stackable.stacksize
								local amount = num and num*(orisize or 1) or orisize or 1
								local max = loot.components.stackable.maxsize
								if amount > max then amount = max end
								loot.components.stackable:SetStackSize(amount)
							elseif loot.components.lootdropper then
								local oldloots = loot.components.lootdropper.loot
								if oldloots and #oldloots >=1 and num then
									local items = {}
									for k, v in pairs(oldloots) do
										for i=1, num do
											table.insert(items, v)
										end
									end
									loot.components.lootdropper.loot = items
								end
							end
						end
						return loot
					end
				end
				return oldpick(selfpick, picker)
			end
		end
	end
end

if not GLOBAL.TheNet:GetIsClient() then
	--新版农场
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	local DEFS = {}
	for k, v in pairs(PLANT_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(WEED_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(DEFS) do
		if not v.data_only then
			AddPrefabPostInit(v.prefab, function(inst)
				farmharvest(inst)
			end)
		end
	end
end

local function RecheckForThreat(inst) --让蝴蝶、鸟等不会逃离
    local busy = inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("flying")
    if not busy then
        local threat = GLOBAL.FindEntity(inst, 5, nil, nil, {'notarget', 'teji_youshan'}, {'player', 'monster', 'scarytoprey'})
        return threat ~= nil
    end
end
 
AddStategraphPostInit("bird", function(sg) --让蝴蝶、鸟等不会逃离2
	local old = sg.events.flyaway.fn
	sg.events.flyaway.fn = function(inst)
		if RecheckForThreat(inst) then
			old(inst)
		end
	end
end)

--开关技能按钮
AddModRPCHandler("DSTtotooria", "Turn", function(player, skillname)
	if not player or player:HasTag("playerghost") then return end
	local tts = player.components.totooriastatus
	local tab = {
		["youshan"]  = {lv=5,  on=tts.youshanon,  stron=13, stroff=17, fn = tts.DoDeltaYoushan},
		["dachu"]    = {lv=10, on=tts.dachuon,    stron=14, stroff=18, fn = tts.DoDeltaDachu},
		["qiaoshou"] = {lv=15, on=tts.qiaoshouon, stron=15, stroff=19, fn = tts.DoDeltaQiaoshou},
		["xuezhe"]   = {lv=20, on=tts.xuezheon,   stron=16, stroff=20, fn = tts.DoDeltaXuezhe},
	}
	if tts.dengji >= tab[skillname].lv then
		if player.components.talker then
			if tab[skillname].on == 1 then
				player.components.talker:Say(uistrs[tab[skillname].stroff].."\n"..uistrs[21])
			else
				player.components.talker:Say(uistrs[tab[skillname].stron].."\n"..uistrs[22])
			end
		end
		tab[skillname].fn(tts, tab[skillname].on==1 and -1 or 1)
	else
		if player.components.talker then
			player.components.talker:Say(uistrs[23].."Lv"..tab[skillname].lv..uistrs[24])
		end
	end
end)

if GetModConfigData("Sound") == true then
    TUNING.ttrsound = "willow"
end
if GetModConfigData("Sound") == false then
    TUNING.ttrsound = "wendy"
end

if GetModConfigData("TotooriaSpeech") == 1 then
    STRINGS.CHARACTERS.TOTOORIA = require "speech_wilson"
end
if GetModConfigData("TotooriaSpeech") == 2 then
    STRINGS.CHARACTERS.TOTOORIA = require "speech_willow"
end
if GetModConfigData("TotooriaSpeech") == 3 then
    STRINGS.CHARACTERS.TOTOORIA = require "speech_wathgrithr"
end
if GetModConfigData("TotooriaSpeech") == 4 then
    STRINGS.CHARACTERS.TOTOORIA = require "speech_wickerbottom"
end

if GetModConfigData("Dig") == true then
    TUNING.candig = 1
end
if GetModConfigData("Hammer") == true then
    TUNING.canhammer = 1
end
TUNING.ttranim = GetModConfigData("TotooriaAnim")

AddMinimapAtlas("images/map_icons/totooria.xml")
AddModCharacter("totooria","FEMALE")