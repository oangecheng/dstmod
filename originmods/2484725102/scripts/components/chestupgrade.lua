local function onbaselv(self, baselv)
	self.inst.replica.chestupgrade:SetBaseLv(baselv)
end

local function onchestlv(self, chestlv)
	self.inst.replica.chestupgrade:SetChestLv(chestlv)
end

local ChestUpgrade = Class(function(self, inst)
	self.inst = inst
	self.baselv = {x = 3, y = 3, z = 1}
	self.chestlv = {x = 3, y = 3, z = 1}
end,
nil,
{
	baselv = onbaselv,
	chestlv = onchestlv,
})

function ChestUpgrade:GetLv()
	return self.chestlv.x, self.chestlv.y, self.chestlv.z
end

function ChestUpgrade:SetBaseLv(x, y, z)
	self:SetChestLv(x, y, z)
	self.baselv = self.chestlv
end

function ChestUpgrade:SetChestLv(x, y, z)
	local container = self.inst.components.container
	if container ~= nil then
		z = z or self.chestlv.z
		if type(x) == "table" then
			x.z = x.z or self.chestlv.z
			self.chestlv = x
		elseif y then
			self.chestlv = {x = x, y = y, z = z}
		elseif container.widget.animbank == "ui_chester_shadow_3x4" then
			self.chestlv = {x = x, y = x + 1, z = z}
		else
			self.chestlv = {x = x, y = x, z = z}
		end
		self:UpdateWidget()
		self.inst:PushEvent("onchestlvchange")
	end
end

--for mods that overwrite containers.widgetsetup and not adding data argument
local function ModCompat(container, widget)
	--remove them from read only so that we can update them
	removesetter(container, "widget")
	removesetter(container, "numslots")

	container.widget = widget
	container.numslots = widget.slotpos ~= nil and #widget.slotpos or 0
	container.inst.replica.chestupgrade:UpdateWidget()

	--make them read only again after update
	makereadonly(container, "widget")
	makereadonly(container, "numslots")
end

function ChestUpgrade:UpdateWidget()
	local container = self.inst.components.container
	local widget = shallowcopy(container.widget)
	local lv_x, lv_y, lv_z = self:GetLv()

	--the widget pos should shift leftward so that it wont block the chest and the player
	widget.pos = Vector3(-65 - 25 * lv_x, 0, 0)		--Vector3(-50 - 30 * lv_x, 0, 0)
	--change the bg scale to make it "fit" to the slot widget
	widget.bgscale = {x = lv_x / self.baselv.x, y = lv_y / self.baselv.y, z = 1}

	--for some container, eg. shadow chester/dragonfly chest
	if widget.animbank == "ui_chester_shadow_3x4" then
		widget.bgscale = {x = lv_x / 3, y = lv_y / 4 * 1.06, z = 0}
		--1.06 is 80/75, the ratio of the widget spacing of treasure chest and dragonfly chest
	end

	--rearrange the slot widget
	widget.slotpos = {}
	for z = 1, lv_z do
		for y = lv_y, 1, -1 do
			for x = 1, lv_x do
				table.insert(widget.slotpos, Vector3(80 * x - 40 * lv_x - 40, 80 * y - 40 * lv_y - 40, 0))
			end
		end
	end

--	container:WidgetSetup(self.inst.prefab, {["widget"] = widget})

	ModCompat(container, widget)
end

local function CheckItem(data, item, ...)
	local prefab, amount
	if type(data) == "string" then
		prefab = data
	elseif type(data) == "table" then
		prefab, amount = data[1], data[2]
	elseif type(data) == "function" then
		return data(item, ...)
	elseif data ~= nil then
		prefab = data.type
		amount = data.amount
	end
--[[
	if amount ~= nil and item ~= nil and item.components.stackable ~= nil and item.components.stackable:StackSize() ~= amount then
		return true
	end

	if not (item ~= nil and item.prefab == prefab or item == prefab) then
		return true
	end

	return false
]]
	return (amount ~= nil and item ~= nil and item.components.stackable ~= nil and item.components.stackable:StackSize() ~= amount)
		or not (item ~= nil and item.prefab == prefab or item == prefab)
end

function ChestUpgrade:CreateCheckTable(data)
	if data == nil then
		data = AllUpgradeRecipes[self.inst.prefab]		--self.ingredient
	end

	local TR = self:GetLv()											--Top right hand coner
	local BR = self.inst.components.container:GetNumSlots()			--Bottom right
	local BL = BR - TR + 1											--Bottom left

	local slot = {}
	if data.all then
		for i = 1, BR do
			slot[i] = data.all
		end
	end

	if data.side then
		for i = 1, TR do slot[i] = data.side end			--top
		for i = BL , BR do slot[i] = data.side end			--bottom
		for i = 1, BL, TR do slot[i] = data.side end		--left
		for i = TR, BR, TR do slot[i] = data.side end		--right
	end

	if data.row then
		for i = 1, TR do
			for k, v in pairs(data.row) do
				local j = (k - 1) * TR + i
				slot[j] = v
			end
		end
	end

	if data.column then
		for i = 1, BL, TR do
			for k, v in pairs(data.column) do
				local j = (k - 1) + i
				slot[j] = v
			end
		end	
	end

	if data.hollow then
		for k = 1, TR - 2 do
			for i = k * TR + 2, k * TR + TR - 1 do
				slot[i] = nil
			end
		end
	end

	if data.center then
		if (BR + 1)%2 == 0 then
			slot[(BR + 1)/2] = data.center
		end
	end

	if data.slot then
		for k, v in pairs(data.slot) do
			slot[k] = v
		end
	end

	return slot
end

function ChestUpgrade:Upgrade(lv, data, doer, fnonly, fn)
	local container = self.inst.components.container
	local x, y, z = self:GetLv()

	if lv ~= nil and (x >= (lv - 1) or y >= lv) or container == nil then return end 	--check for max lv

	local slot = self:CreateCheckTable(data)
	for i = 1, container:GetNumSlots() do
		local item = container.slots[i]
		if CheckItem(slot[i], item, self.inst, doer) then
			return
		end
	end

	container:Close()
	container:DestroyContents()

	if not fnonly then
		self:SetChestLv(x + 2, y + 2)
	end

	if fn ~= nil then
		fn(self.inst, doer, slot)
	end

	self.inst:PushEvent("onchestupgraded", {doer = doer, newlv = {self:GetLv()}, oldlv = {x, y, z}})
end

function ChestUpgrade:Degrade()		--return the chest to normal
	local container = self.inst.components.container
	local side = AllUpgradeRecipes[self.inst.prefab].side		--self.ingredient.side
	if side ~= nil and container ~= nil and container:NumItems() == 1 then
		for i = 1, container:GetNumSlots() do

			local hammer = container.slots[i]

			if hammer ~= nil and hammer:HasTag("HAMMER_tool") then		--use tag so that modded hammer can do degrade

				container:Close()

				if hammer.components.finiteuses ~= nil then				--~=nil check for infinite uses hammer
					local use = math.max(self.chestlv.x - self.baselv.x + self.chestlv.y - self.baselv.y, 0)
					hammer.components.finiteuses:Use(use * TUNING.CHESTUPGRADE.DEGRADE_USE)
				end

				container:DropItemBySlot(i)

				local count = math.max((self.chestlv.x - 2) * (self.chestlv.y - 2) - 1, 0)
				self:SetChestLv(self.baselv)

				local prefab, amount
				if type(side) == "table" then 
					prefab = side[1]
					amount = side[2]
				elseif type(side) == "string" then
					prefab = side
					amount = 1
				elseif side ~= nil then
					prefab = side.type
					amount = side.amount
				else
					break
				end
				for i = 1, math.floor(count * TUNING.CHESTUPGRADE.DEGRADE_RATIO) do
					for j = 1, amount do
						container:GiveItem(SpawnPrefab(prefab))
					end
				end
				break

			end

		end
	end
end

function ChestUpgrade:SpecialUpgrade(data, doer, delta)
	local x, y, z = self:GetLv()
	self:Upgrade(nil, data, doer, true, function()
		self:SetChestLv(x + (delta.x or 0), y + (delta.y or 0), z + (delta.z or 0))
	end)
end

function ChestUpgrade:OnSave()
	local data = {}
	data.chestlv = self.chestlv
	return data
end

function ChestUpgrade:OnLoad(data)
	if data then
		self:SetChestLv(data.chestlv)
	end
end

return ChestUpgrade