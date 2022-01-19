local STRINGS = GLOBAL.STRINGS
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH

local Clanguage = GetModConfigData("language") or "0"
local Credgem = GetModConfigData("redgem") or "0"
local Cbluegem = GetModConfigData("bluegem") or "0"
local Cgear = GetModConfigData("gear") or "0"
local Cpigskin = GetModConfigData("pigskin") or "0"
local Csaltrock = GetModConfigData("saltrock") or "0"
local Cbarnacle = GetModConfigData("barnacle") or "0"
local Cmoonrock = GetModConfigData("moonrock") or "0"
local Clivinglog = GetModConfigData("livinglog") or "0"
local Cmarble = GetModConfigData("marble") or "0"
local Cgold = GetModConfigData("gold") or "0"
local Cthulecite = GetModConfigData("thulecite") or "0"
local Corangegem = GetModConfigData("orangegem") or "0"
local Cyellowgem = GetModConfigData("yellowgem") or "0"
local Cgreengem = GetModConfigData("greengem") or "0"
local Cbutter = GetModConfigData("butter") or "0"
local Ctusk = GetModConfigData("tusk") or "0"
local Cbeargerfur = GetModConfigData("beargerfur") or "0"
local Cgoosefeather = GetModConfigData("goosefeather") or "0"
local Cgoathorn = GetModConfigData("goathorn") or "0"
local Csteelwool = GetModConfigData("steelwool") or "0"
local Clightbulb = GetModConfigData("lightbulb") or "0"
local Cmanrabbittail = GetModConfigData("manrabbittail") or "0"
local Cbatwing = GetModConfigData("batwing") or "0"
local Cfireflies = GetModConfigData("fireflies") or "0"
local Cminotaurhorn = GetModConfigData("minotaurhorn") or "0"
local Copalpreciousgem = GetModConfigData("opalpreciousgem") or "0"
local Chorn = GetModConfigData("horn") or "0"
local Cmole = GetModConfigData("mole") or "0"
local Clureplantbulb = GetModConfigData("lureplantbulb") or "0"


if Clanguage == "1" then
		STRINGS.RECIPE_DESC.REDGEM = "红色的宝石。"
		STRINGS.RECIPE_DESC.BLUEGEM = "蓝色的宝石。"
		STRINGS.RECIPE_DESC.GEARS = "某些机械用品的零件。"
		STRINGS.RECIPE_DESC.PIGSKIN = "散发着猪的味道。"
		STRINGS.RECIPE_DESC.SALTROCK = "很咸的调料。"
		STRINGS.RECIPE_DESC.BARNACLE = "看起来很恐怖。"
		STRINGS.RECIPE_DESC.MOONROCKNUGGET = "这块石头好像来自外太空？"
		STRINGS.RECIPE_DESC.LIVINGLOG = "富有生命活力的木头。"
		STRINGS.RECIPE_DESC.MARBLE = "极其坚硬，比石砖硬得多。"
		STRINGS.RECIPE_DESC.GOLDNUGGET = "金闪闪的金子。"
		STRINGS.RECIPE_DESC.THULECITE = "它好像蕴含魔法。"
		STRINGS.RECIPE_DESC.ORANGEGEM = "橙色的宝石。"
		STRINGS.RECIPE_DESC.YELLOWGEM = "黄色的宝石。"
		STRINGS.RECIPE_DESC.GREENGEM = "绿色的宝石"
		STRINGS.RECIPE_DESC.BUTTER = "甜甜的黄油。"
		STRINGS.RECIPE_DESC.WALRUS_TUSK = "用来作为象牙制作物品的仿制品。"
		STRINGS.RECIPE_DESC.BEARGER_FUR = "非常暖和的熊皮。"
		STRINGS.RECIPE_DESC.GOOSE_FEATHER = "巨大的羽毛。"
		STRINGS.RECIPE_DESC.LIGHTNINGGOATHORN = "小心触电！"
		STRINGS.RECIPE_DESC.STEELWOOL = "像钢丝一样的羊毛。"
		STRINGS.RECIPE_DESC.LIGHTBULB = "浆果，但会闪闪发光。"
		STRINGS.RECIPE_DESC.MANRABBIT_TAIL = "白色的毛。"
		STRINGS.RECIPE_DESC.BATWING = "小恶魔的翅膀。"
		STRINGS.RECIPE_DESC.FIREFLIES = "可爱的会发光的小虫。"
		STRINGS.RECIPE_DESC.MINOTAURHORN = "坚硬且厚重。"
		STRINGS.RECIPE_DESC.OPALPRECIOUSGEM = "散发着彩虹的光芒。"
		STRINGS.RECIPE_DESC.HORN = "以假乱真的牛角。"
		STRINGS.RECIPE_DESC.MOLE = "你为什么可以创造活物？"
		STRINGS.RECIPE_DESC.LUREPLANTBULB = "小心它会长出眼睛！"
	else
		STRINGS.RECIPE_DESC.REDGEM = "A red stone."
		STRINGS.RECIPE_DESC.BLUEGEM = "A blue stone."
		STRINGS.RECIPE_DESC.GEARS = "May used for make machine."
		STRINGS.RECIPE_DESC.PIGSKIN = "It smells really like a pig."
		STRINGS.RECIPE_DESC.SALTROCK = "Tastes very salty."
		STRINGS.RECIPE_DESC.BARNACLE = "It looks terrible."
		STRINGS.RECIPE_DESC.MOONROCKNUGGET = "A stone come from space."
		STRINGS.RECIPE_DESC.LIVINGLOG = "Logs that have life."
		STRINGS.RECIPE_DESC.MARBLE = "It is hard."
		STRINGS.RECIPE_DESC.GOLDNUGGET = "Glittering gold."
		STRINGS.RECIPE_DESC.THULECITE = "There is magic in it."
		STRINGS.RECIPE_DESC.ORANGEGEM = "An orange stone."
		STRINGS.RECIPE_DESC.YELLOWGEM = "A beautiful gem."
		STRINGS.RECIPE_DESC.GREENGEM = "Shining gem."
		STRINGS.RECIPE_DESC.BUTTER = "It cant fly anymore."
		STRINGS.RECIPE_DESC.WALRUS_TUSK = "A fake walrus tooth."
		STRINGS.RECIPE_DESC.BEARGER_FUR = "Very warmful bearfur."
		STRINGS.RECIPE_DESC.GOOSE_FEATHER = "Gaint feather."
		STRINGS.RECIPE_DESC.LIGHTNINGGOATHORN = "Be careful of electric shock!"
		STRINGS.RECIPE_DESC.STEELWOOL = "Very hard that like steel wire."
		STRINGS.RECIPE_DESC.LIGHTBULB = "Beautiful shining fruit."
		STRINGS.RECIPE_DESC.MANRABBIT_TAIL = "White hair."
		STRINGS.RECIPE_DESC.BATWING = "An evil wing."
		STRINGS.RECIPE_DESC.FIREFLIES = "Cute and shining bugs."
		STRINGS.RECIPE_DESC.MINOTAURHORN = "Hard and heavy."
		STRINGS.RECIPE_DESC.OPALPRECIOUSGEM = "Shaning the iridescent light."
		STRINGS.RECIPE_DESC.HORN = "Fake beefalo horn? Or real?"
		STRINGS.RECIPE_DESC.LUREPLANTBULB = "Be careful it will grows eyesss!"
end

if Credgem == "1" then
	else
		AddRecipe("redgem", { Ingredient("rocks", 2), Ingredient("nightmarefuel", 1), Ingredient("berries", 2) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cbluegem == "1" then
	else
		AddRecipe("bluegem", { Ingredient("nitre", 2), Ingredient("nightmarefuel", 1), Ingredient("ice", 2) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cgear == "1" then
	else
		AddRecipe("gears", { Ingredient("flint", 3), Ingredient("transistor", 1), Ingredient("rope", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cpigskin == "1" then
	else
		AddRecipe("pigskin", { Ingredient("meat", 2), Ingredient("beefalowool", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Csaltrock == "1" then
	else
		AddRecipe("saltrock", { Ingredient("spoiled_food", 2), Ingredient("ice", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_ONE)
end

if Cbarnacle == "1" then
	else
		AddRecipe("barnacle", { Ingredient("spoiled_food", 3), Ingredient("nightmarefuel", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cmoonrock == "1" then
	else
		AddRecipe("moonrocknugget", { Ingredient("goldnugget", 1), Ingredient("nightmarefuel", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Clivinglog == "1" then
	else
		AddRecipe("livinglog", { Ingredient("log", 2), Ingredient("nightmarefuel", 1) }, RECIPETABS.REFINE, TECH.MAGIC_TWO)
end

if Cmarble == "1" then
	else
		AddRecipe("marble", { Ingredient("cutstone", 1), Ingredient("nitre", 2) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cgold == "1" then
	else
		AddRecipe("goldnugget", { Ingredient("rocks", 3), Ingredient("petals", 2), Ingredient("nightmarefuel", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cthulecite == "1" then
	else
		AddRecipe("thulecite", { Ingredient("nightmarefuel", 1), Ingredient("nitre", 2), Ingredient("gears", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Corangegem == "1" then
	else
		AddRecipe("orangegem", { Ingredient("cutgrass", 2), Ingredient("nightmarefuel", 1), Ingredient("purplegem", 1) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cyellowgem == "1" then
	else
		AddRecipe("yellowgem", { Ingredient("nightmarefuel", 1), Ingredient("redgem", 2) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cgreengem == "1" then
	else
		AddRecipe("greengem", { Ingredient("nightmarefuel", 1), Ingredient("bluegem", 2) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cbutter == "1" then
	else
		AddRecipe("butter", { Ingredient("butterfly", 1), Ingredient("butterflywings", 2), Ingredient("berries", 1) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Ctusk == "1" then
	else
		AddRecipe("walrus_tusk", { Ingredient("houndstooth", 2), Ingredient("rope", 1), Ingredient("nightmarefuel", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cbeargerfur == "1" then
	else
		AddRecipe("bearger_fur", { Ingredient("beefalowool", 10), Ingredient("transistor", 3), Ingredient("nightmarefuel", 5) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cgoosefeather == "1" then
	else
		AddRecipe("goose_feather", {  Ingredient("feather_robin", 3), Ingredient("feather_crow", 3), Ingredient("nightmarefuel", 1)  }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Cgoathorn == "1" then
	else
		AddRecipe("lightninggoathorn", { Ingredient("houndstooth", 4), Ingredient("rope", 1), Ingredient("goldnugget", 1) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Csteelwool == "1" then
	else
		AddRecipe("steelwool", { Ingredient("beefalowool", 4), Ingredient("gears", 2) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Clightbulb == "1" then
	else
		AddRecipe("lightbulb", { Ingredient("ice", 2), Ingredient("berries", 3) }, RECIPETABS.REFINE, TECH.SCIENCE_ONE)
end

if Cmanrabbittail == "1" then
	else
		AddRecipe("manrabbit_tail", { Ingredient("ice", 1), Ingredient("beefalowool", 2), Ingredient("nightmarefuel", 2) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cbatwing == "0" then
		AddRecipe("batwing", { Ingredient("tentaclespots", 1), Ingredient("twigs", 1), Ingredient("nightmarefuel", 2) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
	elseif Cbatwing == "1" then
		AddRecipe("batwing", { Ingredient("silk", 3), Ingredient("pigskin", 2), Ingredient("nightmarefuel", 2) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
	else
end

if Cfireflies == "1" then
	else
		AddRecipe("fireflies", { Ingredient("lightbulb", 4), Ingredient("gears", 1) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cminotaurhorn == "0" then
		AddRecipe("minotaurhorn", { Ingredient("horn", 3), Ingredient("gears", 2), Ingredient("nightmarefuel", 5) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
	elseif Cminotaurhorn == "1" then
		AddRecipe("minotaurhorn", { Ingredient("walrus_tusk", 4), Ingredient("gears", 2), Ingredient("nightmarefuel", 5) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
	else
end

if Copalpreciousgem == "1" then
	else
		AddRecipe("opalpreciousgem", { Ingredient("purplegem", 1), Ingredient("yellowgem", 1), Ingredient("greengem", 1) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Chorn == "1" then
	else
		AddRecipe("horn", { Ingredient("beefalowool", 3), Ingredient("flint", 5) }, RECIPETABS.REFINE, TECH.SCIENCE_TWO)
end

if Cmole == "1" then
	else
		AddRecipe("mole", { Ingredient("rabbit", 1), Ingredient("nightmarefuel", 2), Ingredient("lightbulb", 2) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end

if Clureplantbulb == "1" then
	else
		AddRecipe("lureplantbulb", { Ingredient("carrot", 3), Ingredient("nightmarefuel", 3), Ingredient("lightbulb", 5) }, RECIPETABS.REFINE, TECH.MAGIC_THREE)
end