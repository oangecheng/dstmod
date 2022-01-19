
local AllRecipes = GLOBAL.AllRecipes
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH
local FOODTYPE = GLOBAL.FOODTYPE

-- antidote is goodies, enables Wigfrid to benefit from it
AddPrefabPostInit("antidote",function(inst)
	if inst.components.edible then
    inst.components.edible.foodtype = FOODTYPE.GOODIES
    end
end)


-- bamboo can be eaten
-- Disabled, for some reason this code causes a fatal memory leak
--
AddPrefabPostInit("bamboo",function(inst)

	if not GLOBAL.TheWorld.ismastersim then
		return
	end

    inst:RemoveComponent("inspectable")
    inst:AddComponent("edible")
	inst.components.edible.healthvalue = 1
	inst.components.edible.hungervalue = 3
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.VEGGIE
	inst.components.edible.sanityvalue = 0
end)
--

-- bamboo can be used to craft papyrus
local papyrus_sortkey = AllRecipes["papyrus"]["sortkey"] -- this hack is needed to not overwrite old papyrus recipe
local bamboopapyrus = AddRecipe(
	"bamboopapyrus",
	{
		Ingredient("bamboo", 3, "images/inventoryimages/bamboo.xml"),
	},
	GLOBAL.RECIPETABS.REFINE,
	GLOBAL.TECH.NONE)
bamboopapyrus.product = "papyrus"
bamboopapyrus.image = "papyrus.tex"
bamboopapyrus.sortkey = papyrus_sortkey + 0.1
bamboopapyrus.numtogive = 1
STRINGS.NAMES.BAMBOOPAPYRUS = "Bamboo papyrus"
STRINGS.RECIPE_DESC.BAMBOOPAPYRUS = "Craft bamboo papyrus!"



---- Done directly in file:
---- Gray pigs are stronger
---- Sharkitten give only one fish instead of 2
-- obsolete, do not work anymore

-- coffee can be cooked with non-cooked coffeebeans
local function change_coffee_after_multiworlds_priority() -- needed to pass over multi worlds original coffee recipe
AddCookerRecipe("cookpot", {		
	name = "coffee",
	test = function(cooker, names, tags)
		local nb_beans = 0
		if names.coffeebeans        then nb_beans = nb_beans + names.coffeebeans end
		if names.coffeebeans_cooked then nb_beans = nb_beans + names.coffeebeans_cooked end
	
		return ((nb_beans == 3 and (names.butter or tags.dairy or names.honey or tags.sweetener))
			   or (nb_beans == 4))
	end,
	priority = 10,
	weight = 1,
	foodtype = "PREPARED",
	health = 3,
	hunger = 10,
	perishtime = TUNING.PERISH_FAST,
	sanity = -5,
	cooktime = .25,
	tags = {},
})
end
	-- awful hack, god forgive me
AddPrefabPostInit("world",function()
	change_coffee_after_multiworlds_priority()
end)
	
-- coffee can be eaten by Wigfrid
AddPrefabPostInit("coffee",function(inst)

	if not GLOBAL.TheWorld.ismastersim then
		return
	end

	inst.components.edible.foodtype = FOODTYPE.GOODIES
	
end)
