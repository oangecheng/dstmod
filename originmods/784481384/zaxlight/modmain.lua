local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local RECIPETABS = GLOBAL.RECIPETABS
local Ingredient = GLOBAL.Ingredient
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH
local LOOK_LANG = GetModConfigData("LOOK_Language")

local LOOK_Recipe = GetModConfigData("RecipenNeed")

PrefabFiles = {
	"foreverlight",
	
}

Assets = {
	
	Asset( "ATLAS", "images/inventoryimages/foreverlight.xml" ),
	Asset( "IMAGE", "minimap/foreverlight.tex" ),
	Asset( "ATLAS", "minimap/foreverlight.xml" ),
}

if LOOK_LANG == "EN" then
	GLOBAL.STRINGS.NAMES.FOREVERLIGHT = "Forever light"
	GLOBAL.STRINGS.RECIPE_DESC.FOREVERLIGHT = "Forever light"
	GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOREVERLIGHT = "turn on at night!"
	
elseif LOOK_LANG == "CH" then
	GLOBAL.STRINGS.NAMES.FOREVERLIGHT = "永亮灯"
	GLOBAL.STRINGS.RECIPE_DESC.FOREVERLIGHT = "永亮灯"
	GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOREVERLIGHT = "夜晚打开"

end


if LOOK_Recipe == "EASY" then
	local foreverlight = GLOBAL.Recipe("foreverlight", {Ingredient("goldnugget", 2), Ingredient("log", 4), Ingredient("fireflies", 2)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, "foreverlight_placer")
	foreverlight.atlas = "images/inventoryimages/foreverlight.xml"
	AddPrefabPostInit("images/inventoryimages/foreverlight.tex")
	AddMinimapAtlas("images/inventoryimages/foreverlight.xml")
elseif LOOK_Recipe == "HARD" then
	
	local foreverlight = GLOBAL.Recipe("foreverlight", {Ingredient("goldnugget", 2), Ingredient("log", 4), Ingredient("lightbulb", 4)}, RECIPETABS.LIGHT, TECH.SCIENCE_TWO, "foreverlight_placer")
	foreverlight.atlas = "images/inventoryimages/foreverlight.xml"
	AddPrefabPostInit("images/inventoryimages/foreverlight.tex")
	AddMinimapAtlas("images/inventoryimages/foreverlight.xml")
end
