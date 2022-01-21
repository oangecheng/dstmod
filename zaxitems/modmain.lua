local _G = GLOBAL
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH


require 'strings_zaxitems_c'


PrefabFiles = {
	"kj",
	"lingdongamulet",	
}

 Assets = {
 	-- 合金铠甲
	Asset("ATLAS", "images/inventoryimages/kj.xml"),
	Asset("IMAGE", "images/inventoryimages/kj.tex"),

	-- 凛冬护符
	Asset( "ATLAS", "images/inventoryimages/lingdongamulet.xml"),
	Asset( "IMAGE", "images/inventoryimages/lingdongamulet.tex"),
}


-- 木质铠甲x1 + 暗影护甲x1 + 大理石甲x1 + 铥矿甲x1 + 雨衣x1
AddRecipe("kj",{GLOBAL.Ingredient("armorwood", 1), GLOBAL.Ingredient("armor_sanity", 1),GLOBAL.Ingredient("armormarble", 1), GLOBAL.Ingredient("armorruins", 1),GLOBAL.Ingredient("raincoat", 1)},
RECIPETABS.SURVIVAL, TECH.NONE, nil, nil, nil, nil, nil, 
"images/inventoryimages/kj.xml", "kj.tex")


-- 生命护符x1 + 寒冬背心x1 + 龙鳞x1 + 橙色宝石x1
AddRecipe("lingdongamulet", {Ingredient("amulet", 1), Ingredient("trunkvest_winter", 1),Ingredient("dragon_scales", 1),Ingredient("orangegem", 1)}, 
RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, nil, "images/inventoryimages/lingdongamulet.xml", "lingdongamulet.tex")

