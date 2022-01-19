GLOBAL.AllUpgradeRecipes = {}

UpgradeRecipe = GLOBAL.Class(function(self, prefab, params)
	self.prefab = prefab
	self.params = params

	GLOBAL.AllUpgradeRecipes[self.prefab] = self
end)

function UpgradeRecipe:GetParams(prefab)
	return self.params ~= nil and self.params or nil
end
--[[
function UpgradeRecipe:AddIngredient(index, ingr)
	local old_ingr = self.params[index]
	if type(old_ingr) ~= "table" then
		self.params[index] = {old_ingr, ingr}
	else
		table.insert(self.params[index], ingr)
	end
end
]]
function UpgradeRecipe:ChangeIngredient(index, ingr)
	self.params[index] = ingr
end

function UpgradeRecipe:GetIngredient(index)
	return self.params[index]
end

function UpgradeRecipe:GetRequirement(index)
	return self.params[index].type, self.params[index].amount
end

function UpgradeRecipe:RemoveIngredient(index)
	self.params[index] = nil
end

function UpgradeRecipe:RemoveRecipe()
	GLOBAL.AllUpgradeRecipes[self.prefab] = nil
end

GLOBAL.UpgradeRecipe = UpgradeRecipe