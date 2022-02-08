-- 添加永久保鲜功能
TUNING.PERISH_FRIDGE_MULT = 0;

local _G = GLOBAL
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH


require 'strings_zaxitems_c'


PrefabFiles = {
	"kj",
	"changchunmao",
	"foreverlight",
}

 Assets = {
 	-- 合金铠甲
	Asset("ATLAS", "images/inventoryimages/kj.xml"),
	Asset("IMAGE", "images/inventoryimages/kj.tex"),

	Asset("ATLAS", "images/inventoryimages/changchunmao.xml"),
	Asset("IMAGE", "images/inventoryimages/changchunmao.tex"),

	Asset( "ATLAS", "images/inventoryimages/foreverlight.xml" ),
	Asset( "IMAGE", "minimap/foreverlight.tex" ),
	Asset( "ATLAS", "minimap/foreverlight.xml" ),
}


-- 木质铠甲x1 + 暗影护甲x1 + 大理石甲x1 + 铥矿甲x1 + 雨衣x1
AddRecipe("kj",{GLOBAL.Ingredient("armorwood", 1), GLOBAL.Ingredient("armor_sanity", 1),GLOBAL.Ingredient("armormarble", 1), GLOBAL.Ingredient("armorruins", 1),GLOBAL.Ingredient("raincoat", 1)},
RECIPETABS.SURVIVAL, TECH.NONE, nil, nil, nil, nil, nil, 
"images/inventoryimages/kj.xml", "kj.tex")

AddRecipe("changchunmao", {Ingredient("silk", 4),Ingredient("goose_feather", 4)}, RECIPETABS.DRESS, TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages/changchunmao.xml", "changchunmao.tex" )


local foreverlight = GLOBAL.Recipe("foreverlight", {Ingredient("goldnugget", 2), Ingredient("log", 4), Ingredient("fireflies", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, "foreverlight_placer")
foreverlight.atlas = "images/inventoryimages/foreverlight.xml"
AddPrefabPostInit("images/inventoryimages/foreverlight.tex")
AddMinimapAtlas("images/inventoryimages/foreverlight.xml")