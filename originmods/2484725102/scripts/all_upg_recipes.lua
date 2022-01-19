local UpgradeRecipe = GLOBAL.UpgradeRecipe

local upgradable_container = 
{
--	[""] = {side = "", center = ""},
	["treasurechest"] 	= {side = Ingredient("boards", 1)},
	["icebox"] 			= {side = Ingredient("cutstone", 1), row = {[1] = Ingredient("gears", 1)}},
	["saltbox"] 		= {side = Ingredient("saltrock", 1), center = Ingredient("bluegem", 1)},
	["dragonflychest"] 	= {side = Ingredient("boards", 1)},
	["fish_box"] 		= {side = Ingredient("rope", 1)},
}

for prefab, params in pairs(upgradable_container) do
	UpgradeRecipe(prefab, params)
end

--[[
if GetModConfigData("ALLCANUPG") then

	--local containers = GLOBAL.require("containers")
	local AllRecipes = GLOBAL.AllRecipes

	for prefab, v in pairs(containers.params) do
		if upgradable_container[prefab] == nil then
			if v.type == "chest" then
				local ingredient = nil
				local amount = 0

				if AllRecipes[prefab] ~= nil then
					local recipe = AllRecipes[prefab]
					for i, ingr in ipairs(recipe.ingredients) do
						if ingr.amount > amount then
							ingredient = ingr.ingredienttype
							amount = ingr.amount
						end
					end
					amount = math.ceil(amount / 3)
					UpgradeRecipe(prefab, {["side"] = Ingredient(ingredient, amount)})
				end

			elseif v.type == "pack" then
				UpgradeRecipe(prefab, {["side"] = Ingredient("waxpaper", 1)})

			end

			local x = 0
			local vec_x
			for k, v in pairs(v.widget.slotpos) do
				if vec_x == nil then
					vec_x = V:Get()
				if vec_x ~= nil and vec_x == v:Get() then
					x = x + 1
				else
					break
				end
			end

			AddPrefabPostInit(prefab, function(inst)
				if not GLOBAL.TheWorld.ismastersim then return end
				local y = inst.components.container:GetNumSlots() / x
				inst:AddComponent("chestupgrade")
				inst.components.chestupgrade:SetBaseLv(x, y)
			end)
		end
	end

end
]]