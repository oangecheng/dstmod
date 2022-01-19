require "SEscripts/itemlist"

local seworldstatus = Class(function(self, inst)
    self.inst = inst
    self.playerdata = {}
    self.repeativecheck = {}

    TUNING.selist_food = {}
	TUNING.selist_cloth = {}
	TUNING.selist_smithing = {}
	TUNING.selist_resource = {}
	TUNING.selist_special = {}

	for n=1, #selist_food do
		TUNING.selist_food[n] = {}
		TUNING.selist_food[n].name = selist_food[n].name
		TUNING.selist_food[n].price = selist_food[n].price
		TUNING.selist_food[n].atlas = selist_food[n].atlas or nil
	end
	for n=1, #selist_cloth do
		TUNING.selist_cloth[n] = {}
		TUNING.selist_cloth[n].name = selist_cloth[n].name
		TUNING.selist_cloth[n].price = selist_cloth[n].price
		TUNING.selist_cloth[n].atlas = selist_cloth[n].atlas or nil
	end
	for n=1, #selist_smithing do
		TUNING.selist_smithing[n] = {}
		TUNING.selist_smithing[n].name = selist_smithing[n].name
		TUNING.selist_smithing[n].price = selist_smithing[n].price
		TUNING.selist_smithing[n].atlas = selist_smithing[n].atlas or nil
	end
	for n=1, #selist_resource do
		TUNING.selist_resource[n] = {}
		TUNING.selist_resource[n].name = selist_resource[n].name
		TUNING.selist_resource[n].price = selist_resource[n].price
		TUNING.selist_resource[n].atlas = selist_resource[n].atlas or nil
	end
	for n=1, #selist_special do
		TUNING.selist_special[n] = {}
		TUNING.selist_special[n].name = selist_special[n].name
		TUNING.selist_special[n].price = selist_special[n].price
		TUNING.selist_special[n].atlas = selist_special[n].atlas or nil
	end

	--点金法杖低价分解珍贵品和专属装备
	TUNING.selist_low = {}
	for n=1, #selist_precious do
	    table.insert(TUNING.selist_low, selist_precious[n])
	end
	for n=1, #selist_special do
	    table.insert(TUNING.selist_low, selist_special[n])
	end
	for n=1, #selist_blueprint do
	    table.insert(TUNING.selist_low, selist_blueprint[n])
	end

	TUNING.SEseasonchange = false

    self:changelist()
    self:seasoncheck()
end)

local tab = {}
for ka,va in pairs(selist_food) do table.insert(tab, va) end
for ka,va in pairs(selist_cloth) do table.insert(tab, va) end
for ka,va in pairs(selist_smithing) do table.insert(tab, va) end
for ka,va in pairs(selist_resource) do table.insert(tab, va) end
--计算配方材料价格总和
function seworldstatus:SumOfRecipePrices(name)
    local recipe = AllRecipes[name]
    local repeative = false
    for kre,vre in pairs(self.repeativecheck) do--循环重复材料检测
    	if name == vre.name then
    		repeative = true
    		break
    	end
    end
    if recipe == nil or repeative then return false end
    table.insert(self.repeativecheck, name)
    local price = 0
    for i,ingredient in ipairs(recipe.ingredients) do
    	local ingreprice = 0
    	for _,tabv in pairs(tab) do
    		if tabv.name == ingredient.type then
    			ingreprice = (tabv.price or 0)*1.5
    			break
    		end
    	end
    	if ingreprice == 0 then--如果不能在itemlist里找到价格则计算下一层配方价格之和
	    	local sumprice = self:SumOfRecipePrices(ingredient.type)
	    	ingreprice = sumprice ~= 0 and sumprice or ingreprice
	    end
        price = price + ingreprice*(ingredient.amount or 1)
    end
    return math.ceil(price/(recipe.numtogive or 1))
end

function seworldstatus:changelist()
	--判定张跌
	local curseason = TheWorld.components.worldstate.data.season
	TUNING.seseasonfood = curseason == "spring" and .5 or curseason == "winter" and 1.5 or 1
	TUNING.seseasoncloth = curseason == "summer" and .5 or curseason == "winter" and 1.5 or 1
	TUNING.seseasonsmithing = curseason == "winter" and .5 or curseason == "summer" and 1.5 or 1
	TUNING.seseasonresource = curseason == "autumn" and .5 or curseason == "summer" and 1.5 or 1

	--改变价格，优先使用itemlist里定好的价格，如果没有定，则计算配方材料价格总和
	for k,v in pairs(selist_food) do
		TUNING.selist_food[k].price = math.ceil((v.price or self:SumOfRecipePrices(v.name) or 5200)*TUNING.seseasonfood)
		if TUNING.selist_food[k].price > 9999 then TUNING.selist_food[k].price = 9999 end
		self.repeativecheck = {}
	end
	for k,v in pairs(selist_cloth) do
		TUNING.selist_cloth[k].price = math.ceil((v.price or self:SumOfRecipePrices(v.name) or 5200)*TUNING.seseasoncloth)
		if TUNING.selist_cloth[k].price > 9999 then TUNING.selist_cloth[k].price = 9999 end
		self.repeativecheck = {}
	end
	for k,v in pairs(selist_smithing) do
		TUNING.selist_smithing[k].price = math.ceil((v.price or self:SumOfRecipePrices(v.name) or 5200)*TUNING.seseasonsmithing)
		if TUNING.selist_smithing[k].price > 9999 then TUNING.selist_smithing[k].price = 9999 end
		self.repeativecheck = {}
	end
	for k,v in pairs(selist_resource) do
		TUNING.selist_resource[k].price = math.ceil((v.price or self:SumOfRecipePrices(v.name) or 5200)*TUNING.seseasonresource)
		if TUNING.selist_resource[k].price > 9999 then TUNING.selist_resource[k].price = 9999 end
		self.repeativecheck = {}
	end

	--合并清单供点金法杖使用
	TUNING.allgoods = {}
	for n=1, #TUNING.selist_food do
	    table.insert(TUNING.allgoods, TUNING.selist_food[n])
	end
	for n=1, #TUNING.selist_cloth do
	    table.insert(TUNING.allgoods, TUNING.selist_cloth[n])
	end
	for n=1, #TUNING.selist_smithing do
	    table.insert(TUNING.allgoods, TUNING.selist_smithing[n])
	end
	for n=1, #TUNING.selist_resource do
	    table.insert(TUNING.allgoods, TUNING.selist_resource[n])
	end

	--ui辅助
	if TUNING.SEseasonchange == false then
		TUNING.SEseasonchange = true
	else
		TUNING.SEseasonchange = false
	end
end

function seworldstatus:seasoncheck()
	TheWorld:ListenForEvent("seasontick", function()
		self:changelist()
	end)
end

function seworldstatus:OnSave()
    local data = {
    	playerdata = self.playerdata,
	}
    return data
end

function seworldstatus:OnLoad(data)
    self.playerdata = data.playerdata or {}
end

return seworldstatus