local function OnBaseLv(inst)
	inst.replica.chestupgrade.baselv = shallowcopy(inst.replica.chestupgrade.chestlv)
end

local function OnChestLv(inst)
	local clv = inst.replica.chestupgrade.net_clv:value()
	if TUNING.CHESTUPGRADE.MAX_PAGE == 1 and TUNING.CHESTUPGRADE.MAX_LV <= 15 then
		inst.replica.chestupgrade.chestlv.x = bit.band(clv, 15)
		inst.replica.chestupgrade.chestlv.y = bit.rshift(clv, 4)
	else
		inst.replica.chestupgrade.chestlv.x = bit.band(clv, 63)
		inst.replica.chestupgrade.chestlv.y = bit.rshift(bit.band(clv, 4032), 6)
		inst.replica.chestupgrade.chestlv.z = bit.rshift(clv, 12)
	end
	inst.replica.chestupgrade:UpdateWidget()
end

local function OnChestLvDirty(inst)
	inst.replica.chestupgrade.chestlv.x = inst.replica.chestupgrade.net_lvx:value()
	inst.replica.chestupgrade.chestlv.y = inst.replica.chestupgrade.net_lvy:value()
	inst.replica.chestupgrade.chestlv.z = inst.replica.chestupgrade.net_lvz:value()
	inst.replica.chestupgrade:UpdateWidget()
end

local ChestUpgrade = Class(function(self, inst)
	self.inst = inst
	self.baselv = {x = 3, y = 3, z = 1}
	self.net_blv = net_event(self.inst.GUID, "onbaselv")

	self.chestlv = {x = 3, y = 3, z = 1}
	if TUNING.CHESTUPGRADE.MAX_PAGE == 1 and TUNING.CHESTUPGRADE.MAX_LV <= 15 then
		self.net_clv = net_byte(self.inst.GUID, "chestlv", "onchestlv")
	elseif TUNING.CHESTUPGRADE.MAX_LV <= 63 then
		self.net_clv = net_ushortint(self.inst.GUID, "chestlv", "onchestlv")
	else
		self.net_lvx = net_ushortint(self.inst.GUID, "chestlvx", "onchestlvdirty")
		self.net_lvy = net_ushortint(self.inst.GUID, "chestlvy", "onchestlvdirty")
		self.net_lvz = net_ushortint(self.inst.GUID, "chestlvz", "onchestlvdirty")
	end

	if not TheWorld.ismastersim then
		self.inst:ListenForEvent("onbaselv", OnBaseLv)
		self.inst:ListenForEvent("onchestlv", OnChestLv)
		self.inst:ListenForEvent("onchestlvdirty", OnChestLvDirty)
	end
end)

function ChestUpgrade:GetLv()
	return self.chestlv.x, self.chestlv.y, (TUNING.CHESTUPGRADE.MAX_PAGE ~= 1 and self.chestlv.z or 1)
end

function ChestUpgrade:SetBaseLv(baselv)
	self:SetChestLv(baselv)
	self.baselv = self.chestlv
	self.net_blv:push()
end

function ChestUpgrade:SetChestLv(chestlv)
	self.chestlv = chestlv

	if TUNING.CHESTUPGRADE.MAX_PAGE == 1 and TUNING.CHESTUPGRADE.MAX_LV <= 15 then
		local clv = chestlv.x + bit.lshift(chestlv.y, 4)
		self.net_clv:set(clv)
	elseif TUNING.CHESTUPGRADE.MAX_LV <= 63 then
		local clv = chestlv.x + bit.lshift(chestlv.y, 6) + bit.lshift(chestlv.z, 12)
		self.net_clv:set(clv)
	else
		self.net_lvx:set(chestlv.x)
		self.net_lvy:set(chestlv.y)
		self.net_lvz:set(chestlv.z)
	end
end

function ChestUpgrade:CreateCheckTable(data)
	if data == nil then
		data = AllUpgradeRecipes[self.inst.prefab]		--self.ingredient
	end

	local TR = self:GetLv()											--Top right hand coner
	local BR = self.inst.replica.container:GetNumSlots()			--Bottom right
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

local function ModCompat(container, widget)
	container.widget = widget

	container:SetNumSlots(widget.slotpos ~= nil and #widget.slotpos or 0)

	if container.classified ~= nil then
		container.classified:InitializeSlots(container:GetNumSlots())
	end
	if container.issidewidget then
		if container._onputininventory == nil then
			container._owner = nil
			container._ondropped = function(inst)
				if container._owner ~= nil then
					local owner = container._owner
					container._owner = nil
					if owner.HUD ~= nil then
						owner:PushEvent("refreshcrafting")
					end
				end
			end
			container._onputininventory = function(inst, owner)
				container._ondropped(inst)
				container._owner = owner
				if owner ~= nil and owner.HUD ~= nil then
					owner:PushEvent("refreshcrafting")
				end
			end
			container.inst:ListenForEvent("onputininventory", container._onputininventory)
			container.inst:ListenForEvent("ondropped", container._ondropped)
		end
	end
end

function ChestUpgrade:UpdateWidget()
	local container = self.inst.replica.container
	if container == nil then return end
	container:Close()

	local widget = deepcopy(container:GetWidget())
	local lv_x, lv_y, lv_z = self:GetLv()

	widget.slotpos = {}
	for z = 1, lv_z do
		for y = lv_y, 1, -1 do
			for x = 1, lv_x do
				table.insert(widget.slotpos, Vector3(80 * x - 40 * lv_x - 40, 80 * y - 40 * lv_y - 40, 0))
			end
		end
	end

	if self.drag then
		lv_x = math.min(self.drag, lv_x)
		lv_y = math.min(self.drag, lv_y)
	end
	if self.uipos then
		widget.pos = Vector3(-65 - 25 * lv_x, 0, 0)
	else
		widget.pos = Vector3(0, 80 + 30 * lv_y, 0)
	end
	widget.bgscale = {x = lv_x / self.baselv.x, y = lv_y / self.baselv.y, z = 1}

	if widget.animbank == "ui_chester_shadow_3x4" then
		widget.bgscale = {x = lv_x / 3, y = lv_y / 4 * 1.06, z = 0}
	end
--	container:WidgetSetup(self.inst.prefab, {["widget"] = widget})

	ModCompat(container, widget)
end

return ChestUpgrade