local Ingredient = GLOBAL.Ingredient
local TECH = GLOBAL.TECH

--------Custom Crafting Tab
local amelia_tab = AddRecipeTab("Amelia", 99, "images/inventoryimages/bubba_tab.xml", "bubba_tab.tex", "amelia")

--Items' recipes
if TUNING.AMELIA_WATCH_RECIPE == 0 then
	AddRecipe("amelia_watch",
	{
		Ingredient("saltrock", 5),
		Ingredient("goldnugget", 2),
		Ingredient("nightmarefuel", 2),
	},
	amelia_tab, TECH.NONE, nil, nil, nil, 1, "amelia", "images/inventoryimages/amelia_watch_icon.xml"
	,  "amelia_watch_icon.tex")
elseif TUNING.AMELIA_WATCH_RECIPE == 1 then
	AddRecipe("amelia_watch",
	{
		Ingredient("saltrock", 5),
		Ingredient("transistor", 2),
		Ingredient("nightmarefuel", 3),
	},
	amelia_tab, TECH.NONE, nil, nil, nil, 1, "amelia", "images/inventoryimages/amelia_watch_icon.xml"
	,  "amelia_watch_icon.tex")
else
	AddRecipe("amelia_watch",
	{
		Ingredient("saltrock", 7),
		Ingredient("transistor", 3),
		Ingredient("nightmarefuel", 5),
	},
	amelia_tab, TECH.NONE, nil, nil, nil, 1, "amelia", "images/inventoryimages/amelia_watch_icon.xml"
	,  "amelia_watch_icon.tex")
end

if TUNING.WATSON_CONCOCTION_RECIPE == 0 then
	AddRecipe("watson_concoction",
	{
		Ingredient("saltrock", 3),
        Ingredient("blue_cap", 1),
        Ingredient("stinger", 1),
    },
    amelia_tab, TECH.NONE, nil, nil, nil, 1, "amelia", "images/inventoryimages/watson_concoction.xml"
	,  "watson_concoction.tex")
else
    AddRecipe("watson_concoction",
    {
		Ingredient("saltrock", 3),
		Ingredient("moon_cap", 1),
		Ingredient("stinger", 1),
    },
	amelia_tab, TECH.NONE, nil, nil, nil, 1, "amelia", "images/inventoryimages/watson_concoction.xml"
	,  "watson_concoction.tex")
end
AddRecipe("amelia_magnifying_glass",
{
	Ingredient("saltrock", 2),
	Ingredient("goldnugget", 1),
	Ingredient("twigs", 2),
},
amelia_tab, TECH.NONE, nil, nil, nil, 1, "amelia", "images/inventoryimages/amelia_magnifying_glass_icon.xml"
,  "amelia_magnifying_glass_icon.tex")
