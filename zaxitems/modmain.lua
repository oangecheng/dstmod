local _G = GLOBAL
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

PrefabFiles = {
	"kj"
}

 Assets = {
	Asset("ATLAS", "images/inventoryimages/kj.xml"),			--铠甲
	Asset("IMAGE", "images/inventoryimages/kj.tex"),
}


AddRecipe("kj",{GLOBAL.Ingredient("armorwood", 1), GLOBAL.Ingredient("armor_sanity", 1),GLOBAL.Ingredient("armormarble", 1), GLOBAL.Ingredient("armorruins", 1),GLOBAL.Ingredient("raincoat", 1)},
RECIPETABS.SURVIVAL, TECH.NONE, nil, nil, nil, nil, nil, 
"images/inventoryimages/kj.xml", "kj.tex")