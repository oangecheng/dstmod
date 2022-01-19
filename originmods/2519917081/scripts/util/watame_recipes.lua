local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH
local RECIPETABS = GLOBAL.RECIPETABS

--------Custom Crafting Tab
local watame_tab = AddRecipeTab("Watame", 99, "images/hud/watametab.xml", "watametab.tex", "watame")

--Items' recipes
if TUNING.WATAME_SHOGUN_RECIPE == 0 then
    AddRecipe("watame_shogun",
    {
        Ingredient("cutstone", 2),
        Ingredient("goldnugget", 2),
        Ingredient("steelwool", 1),
    },
	watame_tab, TECH.NONE, nil, nil, nil, 1, "watame", "images/inventoryimages/watame_shogun.xml", "watame_shogun.tex")
end
if TUNING.WATAME_KATANA_RECIPE == 0 then
    AddRecipe("watame_katana",
    {
        Ingredient("flint", 5),
        Ingredient("rope", 2),
        Ingredient("steelwool", 1),
    },
	watame_tab, TECH.NONE, nil, nil, nil, 1, "watame", "images/inventoryimages/watame_katana.xml", "watame_katana.tex")
end