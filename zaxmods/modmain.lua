-- 添加永久保鲜功能
TUNING.PERISH_FRIDGE_MULT = 0;

local _G = GLOBAL
	_G.ENABLE_ZAXHAT = GetModConfigData("EnableZaxHat")

local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH


require 'strings_zaxitems_c'


PrefabFiles = {
	"changchunmao",
}

 Assets = {
	Asset("ATLAS", "images/inventoryimages/changchunmao.xml"),
	Asset("IMAGE", "images/inventoryimages/changchunmao.tex"),
}


-- 添加牛牛帽合成
if _G.ENABLE_ZAXHAT then 
	AddRecipe("changchunmao", 
	{Ingredient("silk", 4),Ingredient("goose_feather", 4)}, 
	RECIPETABS.DRESS, TECH.NONE, nil, nil, nil, nil, nil, 
	"images/inventoryimages/changchunmao.xml", "changchunmao.tex" )
end 

