TUNING.CHESTUPGRADE = {	--add to tuning so that they can be easily tuned
	MAX_LV			= GetModConfigData("MAX_LV"),
	DEGRADE_RATIO	= .5,						--math.min(GetModConfigData("DEGRADE_RATIO"), 1)
	DEGRADE_USE		= 1,						--GetModConfigData("DEGRADE_USE")
	MAX_PAGE		= GetModConfigData("PAGEABLE") and 10 or 1,

	SCALE_FACTOR	= GetModConfigData("SCALE_FACTOR"),
}

local containers = GLOBAL.require("containers")

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, (TUNING.CHESTUPGRADE.MAX_LV ^ 2 + TUNING.CHESTUPGRADE.MAX_LV) * TUNING.CHESTUPGRADE.MAX_PAGE)

AddReplicableComponent("chestupgrade")

-------------ON_PROGRESS-------------
--[[
modimport("upgrade_recipe.lua")
modimport("all_upg_recipes.lua")
]]

----------------------MAIN----------------------

local upgradable_container = 
{
--	[""] = {side = "", center = ""},
	["treasurechest"] 	= {side = {"boards", 1}},
	["icebox"] 			= {side = {"cutstone", 1}, row = {[1] = {"gears", 1}}},
	["saltbox"] 		= {side = {"saltrock", 1}, center = {"bluegem", 1}},
	["dragonflychest"] 	= {side = {"boards", 1}},
	["fish_box"] 		= {side = {"rope", 1}},
}

GLOBAL.AllUpgradeRecipes = upgradable_container

--return some resource when deconstruct
local function ondeconstruct(staff, item)
	return function(inst, data)
		if staff or data.workleft <= 0 then
			local x, y, z = inst.Transform:GetWorldPosition()
			local lv_x, lv_y = inst.components.chestupgrade:GetLv()
			local itemback = (staff and math.floor((lv_x - 2) * (lv_y - 2) - 1))
							or math.floor((lv_x - 2) * (lv_y - 2) / 2)
			if itemback < 1 then return end
			local prefab, amount
			if type(item) == "table" then 
				prefab = item[1]
				amount = item[2]
			elseif type(item) == "string" then
				prefab = item
				amount = 1
			elseif prefab ~= nil then
				prefab = item.type
				amount = item.amount
			else
				return
			end
			for i = 1, itemback do
				for j = 1, amount do
					GLOBAL.SpawnPrefab(prefab).Transform:SetPosition(x + math.random() * 2 - 1, y, z + math.random() * 2 - 1)
				end
			end
		end
	end
end

local function GetSUpgData(prefab, mode, x, y, z)
	local data = {
		slot = {},
	}
	local major, minor
	for k, v in pairs(upgradable_container[prefab]) do
		if k == "side" then
			major = v
		else
			minor = k == "row" and v[1] or v
		end
	end
	if mode == 0 then		--page
		for i = 1, x * y do
			table.insert(data.slot, major)
		end
	elseif mode == 1 then	--column
		data.column = {}
		data.column[x] = major
		data.slot[x] = minor
	elseif mode == 2 then	--row
		local i = x * y - x + 1
		data.row = {}
		data.row[y] = major
		data.slot[i] = minor
	end
	return data
end

--change chest size scaled to its level
local function changesize(inst)
	local cupg = inst.components.chestupgrade
	local clv = cupg.chestlv
	local blv = cupg.baselv
	inst.Transform:SetScale(
		(clv.x / blv.x - 1) / TUNING.CHESTUPGRADE.SCALE_FACTOR + 1,
		(clv.y / blv.y - 1) / TUNING.CHESTUPGRADE.SCALE_FACTOR + 1,
		1
	)
end

for k, v in pairs(upgradable_container) do
	if GetModConfigData("C_"..k:upper()) then

		--hide bgimage
		if GetModConfigData("UI_BGIMAGE", true) then
			containers.params[k].widget.animbuild = nil
			containers.params[k].widget.animbank = nil
		end
		--make the widget to the left
		if GetModConfigData("UI_WIDGETPOS", true) then
			containers.params[k].widget.pos = GLOBAL.Vector3(-140, 0, 0)
		end

		--make upgd items can be put into the container
		local OLD_itemtestfn = containers.params[k].itemtestfn
		if OLD_itemtestfn ~= nil then
			containers.params[k].itemtestfn = function(container, item, slot)
				for _, prefab in pairs(v) do
					while type(prefab) == "table" do
						prefab = prefab[1]
					end
					if type(prefab) == "string" and item.prefab == prefab then
						return true
					end
				end

				return item:HasTag("HAMMER_tool")
					or OLD_itemtestfn(container, item, slot)
			end
		end

		--check if upgrade posible when the container is closed
		local function onclose(inst, data)
			local container = inst.components.container
			--upgrade only if all player close the container
			if container.opencount == 0 then

				local chestupgrade = inst.components.chestupgrade
				local x, y, z = chestupgrade:GetLv()

				--upgd mode: 1: normal; 2: row/column; 3: both 1 & 2
				if GetModConfigData("UPG_MODE") ~= 1 then
					--column upgd
					if x < TUNING.CHESTUPGRADE.MAX_LV then
						chestupgrade:SpecialUpgrade(GetSUpgData(inst.prefab, 1, x, y, z), data.doer, {x = 1})
					end
					--row upgd
					if y < TUNING.CHESTUPGRADE.MAX_LV then
						chestupgrade:SpecialUpgrade(GetSUpgData(inst.prefab, 2, x, y, z), data.doer, {y = 1})
					end
				end

				--normal upgd
				if GetModConfigData("UPG_MODE") ~= 2 then
					chestupgrade:Upgrade(TUNING.CHESTUPGRADE.MAX_LV, v, data.doer)
				end

				--page upgd
				if GetModConfigData("PAGEABLE")then
					--can be upgd only when it is in max lv
					if x * y >= TUNING.CHESTUPGRADE.MAX_LV ^ 2 and z < TUNING.CHESTUPGRADE.MAX_PAGE then
						chestupgrade:SpecialUpgrade(GetSUpgData(inst.prefab, 0, x, y, z), data.doer, {z = 1})
					end
				end

				--degrade-able
				if GetModConfigData("DEGRADABLE") then
					if x > chestupgrade.baselv.x or y > chestupgrade.baselv.y or z > chestupgrade.baselv.z then
						chestupgrade:Degrade()
					end
				end

				--drop upgd material that are not able to put in to the container
				if OLD_itemtestfn ~= nil then
					for i = 1, container:GetNumSlots() do 
						local item = container.slots[i]
						if item ~= nil and not OLD_itemtestfn(container, item, i) then
							container:DropItemBySlot(i)
						end
					end
				end

			end
		end

		AddPrefabPostInit(k, function(inst)
			if not GLOBAL.TheWorld.ismastersim then return end
			inst:AddComponent("chestupgrade")
			if k == "dragonflychest" or k == "fish_box" then
				inst.components.chestupgrade:SetBaseLv(3, 4)
			end

			--check if upgd possible onclose
			--could be costomize, like check upgd when "isfullmoon", or when "oncyclechange"
			inst:ListenForEvent("onclose", onclose)

			--some testing function
			if GetModConfigData("CHANGESIZE") then
				inst:ListenForEvent("onchestlvchange", changesize)
			end

			--return item after hammered or deconstructed
			if GetModConfigData("RETURNITEM") then
				inst:ListenForEvent("worked", ondeconstruct(false, v.side))
				inst:ListenForEvent("ondeconstructstructure", ondeconstruct(true, v.side))
			end

			--DEBUG MODE
			if GetModConfigData("DEBUG_MAXLV") then
				inst.components.chestupgrade:SetChestLv(TUNING.CHESTUPGRADE.MAX_LV, TUNING.CHESTUPGRADE.MAX_LV, TUNING.CHESTUPGRADE.MAX_PAGE)
			end

			if GetModConfigData("DEBUG_IIC") then
				for para, data in pairs(v) do
					local n = 1
					if para == "side" then n = 5 end
					for m = 1, n do
						local item = GLOBAL.SpawnPrefab(data[1])
						local stackable = item.components.stackable
						stackable:SetStackSize(stackable.maxsize)
						inst.components.container:GiveItem(item)
					end
				end
			end
		end)

	end
end

AddClassPostConstruct("components/chestupgrade_replica", function(self, inst)
	if GetModConfigData("DRAGGABLE", true) then
		self.drag = true
	end
	if GetModConfigData("UI_WIDGETPOS", true) then
		self.uipos = true
	end
end)


--------------------WIDGET----------------------
modimport("scripts/strings")

--loc
--[[
local function CheckTranslate()
	local locale = GLOBAL.LanguageTranslator.defaultlang
	for i, v in ipairs(LANGUAGE) do
		if v == locale then
			return locale
		end
	end
	return "en"
end
local loc = CheckTranslate()
]]
local function IsChinese()
	local locale = GLOBAL.LanguageTranslator.defaultlang
	return locale == "zh" or locale == "zht"
end
local loc = IsChinese() and "zh" or "en"

--rpc
AddModRPCHandler("RPC_UPGCHEST", "sortcontent", function(doer, inst)
	local container = inst.components.container
	if container ~= nil and inst.components.chestupgrade ~= nil then
		local x, y, z = inst.components.chestupgrade:GetLv()
		local prefab = upgradable_container[inst.prefab].side[1]
		if z < TUNING.CHESTUPGRADE.MAX_PAGE and container:Has(prefab, x * y) and prefab ~= nil then
			--SendModRPCToServer(GetModRPC("RPC_UPGCHEST", "dropallitem"), container)
			local items = {}
			local numtoget = x * y
			for k, v in pairs(container.slots) do
				if numtoget ~= 0 and v.prefab == prefab then
					local size = v.components.stackable:StackSize()
					if size <= numtoget then
						table.insert(items, container:RemoveItem(v, true))
						numtoget = numtoget - size
					else
						local item = container:RemoveItem(v, true)
						table.insert(items, item.components.stackable:Get(numtoget))
						numtoget = 0
						item.Transform:SetPosition(inst:GetPosition():Get())
						if item.components.inventoryitem ~= nil then
							item.components.inventoryitem:OnDropped(true)
						end
						item.prevcontainer = nil
						item.prevslot = nil
						inst:PushEvent("dropitem", {item = item})

					end
				else
					container:DropItemBySlot(k)
				end
			end
			for i, v in ipairs(items) do
				local size = v.components.stackable:StackSize()
				if size >= 2 then
					for n = 1, size - 1 do
						table.insert(items, v.components.stackable:Get())
					end
				end
				container:GiveItem(v, i)
			end
		else
			local t = {}
			local i = 0
			local last = container:GetNumSlots()
			local items = container:RemoveAllItems()
			for k, v in pairs(items) do
				local slot = 0
				if t[v.prefab] == nil then
					t[v.prefab] = {}
					slot = i * x + 1
					i = i + 1
				elseif #t[v.prefab] < y then
					slot = t[v.prefab][1] + #t[v.prefab]
				else
					slot = last
					last = last - 1
				end
				table.insert(t[v.prefab], slot)
				container:GiveItem(v, slot)
				v.prevcontainer = nil
				v.prevslot = nil
			end
		end
	end
end)

--container widget
local function onchestlv()
	local config = {{name = "SHOWGUIDE", saved = false}}
	GLOBAL.KnownModIndex:SaveConfigurationOptions(function() end, modname, config, true)
end
local function cleantask(inst, container)
	inst:RemoveEventCallback("onchestlv", onchestlv, container)
end

local ImageButton = GLOBAL.require("widgets/imagebutton")
local ChestPage = GLOBAL.require("widgets/chestpage")
local DragContainer = GLOBAL.require("widgets/dragcontainer")
AddClassPostConstruct("widgets/containerwidget", function(self)
	local OLD_Open = self.Open
	function self:Open(container, doer, ...)
		OLD_Open(self, container, doer, ...)

		local chestupgrade = container.replica.chestupgrade
		if chestupgrade == nil then return end
		local lv_x, lv_y, lv_z = chestupgrade:GetLv()

		--show upgrade requirment
		if GetModConfigData("UPG_MODE") ~= 2 and GetModConfigData("SHOWGUIDE", true)
		and (lv_x < TUNING.CHESTUPGRADE.MAX_LV and lv_y < TUNING.CHESTUPGRADE.MAX_LV) then
			local slots = chestupgrade:CreateCheckTable()
			for k, v in pairs(slots) do
				self.inv[k]:SetBGImage2(GLOBAL.resolvefilepath(GLOBAL.GetInventoryItemAtlas(v[1]..".tex")), v[1]..".tex", {1, 1, 1, .4})
			end
		end

		--change the bg scale
		local widget = container.replica.container:GetWidget()
		if widget.bgscale ~= nil then
			self.bganim:SetScale(widget.bgscale)
		end

		--shift the widget leftward if you are on the boat, or the container is icebox or saltbox
		local p = doer:GetCurrentPlatform()
		local uipos = GetModConfigData("UI_WIDGETPOS", true)
		if uipos then
			if (widget.pos ~= nil and p ~= nil) or (GetModConfigData("UI_ICEBOX", true) and (container.prefab == "icebox" or container.prefab == "saltbox")) then	
				local rhs = {x = -140, y = 0, z = 0}
				self:SetPosition(widget.pos:__add(rhs))
			end
		end

		--draggable widget
		local drag = GetModConfigData("DRAGGABLE", true)
		if drag and (drag < lv_x or drag < lv_y) then
			local show = {math.min(drag, lv_x), math.min(drag, lv_y)}
			local total = {lv_x, lv_y}
			local scale = {show[1] / total[1], show[2] / total[2]}
			if uipos then
				self.dragwidget = self:AddChild(DragContainer("images/hud.xml", "craftingsubmenu_fullvertical.tex", scale, show, total))
				self.dragwidget:SetPosition(0, 300 + 40 * (show[2] - 1), 0)
				self.dragwidget.bgimg:SetScale(1, -3/4, 1)
				self.dragwidget.bgimg:SetPosition(0, -24, 0)
			else
				self.dragwidget = self:AddChild(DragContainer("images/hud.xml", "craftingsubmenu_fullhorizontal.tex", scale, show, total))
				self.dragwidget:SetPosition(-300 - 40 * (show[1] - 1), 0, 0)
				self.dragwidget.bgimg:SetScale(-1, 3/4, 1)
				self.dragwidget.bgimg:SetPosition(32, 0, 0)
			end
			self.dragwidget:SetShowPos()
			self.dragwidget:ShowSection()
		end

		--shows the pageable button
		if lv_z ~= nil and lv_z > 1 then
			self.chestpage = self:AddChild(ChestPage(chestupgrade))
			self.chestpage:SetPosition((drag and math.min(drag, lv_x) or lv_x) * 40 + 30, 0, 0)
			self.chestpage:PageChange(0)
		end

		--button: drop all item
		if GetModConfigData("DROPALL", true) then
			self.dropallbtn = self:AddChild(ImageButton("images/ui.xml", "button_small.tex", "button_small_over.tex", "button_small_disabled.tex", nil, nil, {.8,1.2}, {0,0}))
			self.dropallbtn:SetPosition(0, (drag and math.min(drag, lv_y) or lv_y) * -40 - 30, 0)
			self.dropallbtn:SetWhileDown(function()
				if self.inv ~= nil and #self.inv > 0 then
					for i, v in ipairs(self.inv) do
						if v.tile and v.tile.item then
							v:DropItem()
							break
						end
					end
				end
			end)
			self.dropallbtn:SetText(DROPALLTEXT[loc])
			self.dropallbtn:SetFont(GLOBAL.BUTTONFONT)
			self.dropallbtn:SetTextSize(30)
		end
	end

	local OLD_Close = self.Close
	function self:Close(...)
		if self.isopen then
			if GetModConfigData("SHOWGUIDE", true) == 3 and self.container ~= nil then
				local ThePlayer = GLOBAL.ThePlayer
				ThePlayer:ListenForEvent("onchestlv", onchestlv, self.container)
				ThePlayer:DoTaskInTime(3, cleantask, self.container)
			end
			if self.dragwidget ~= nil then
				self.dragwidget:Kill()
				self.dragwidget = nil
			end
			if self.chestpage ~= nil then
				self.chestpage:Kill()
				self.chestpage = nil
			end
			if self.dropallbtn ~= nil then
				self.dropallbtn:Kill()
				self.dropallbtn = nil
			end
		end
		OLD_Close(self, ...)
	end
end)

----------------MOD-------------------
--Insight
if GetModConfigData("INSIGHT") and GLOBAL.KnownModIndex:IsModEnabled("workshop-2189004162") then
	local function AddDescriptors()
		GLOBAL.Insight.descriptors.chestupgrade = {
			Describe = function(self, context)
				local lang = (context.config.language == "automatic" and IsChinese() or context.config.language == "zh") and "zh" or "en"
				local text = DESCRIBE[lang]

				local description
				if TUNING.CHESTUPGRADE.MAX_PAGE > 1 then
					description = string.format(text.pageable, self:GetLv())
				else
					description = string.format(text.generic, self:GetLv())
				end

				return {
					priority = 0,
					description = description
				}
			end
		}
	end

	AddSimPostInit(AddDescriptors)
end