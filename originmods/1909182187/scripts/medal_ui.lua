---------------------------------------------------------------------------------------------------------
-------------------------------------------ICON、状态徽章------------------------------------------------
---------------------------------------------------------------------------------------------------------

--勋章说明页
if TUNING.HAS_MEDAL_PAGE_ICON then
	local medalPage = require("widgets/medalPage")
	local function addPageIconWidget(self)
		--说明页图标
		self.medalPage = self:AddChild(medalPage())
	end
	AddClassPostConstruct("widgets/controls", addPageIconWidget)
end

--饱食下降箭头动画
local function hungerDownAnim(self)
	local oldOnUpdate=self.OnUpdate
	self.OnUpdate = function(dt)
		local anim = "neutral"
		local hungerrate = 1--饱食下降速度
		if self.owner and self.owner.medal_hungerrate then
			if self.owner.medal_hungerrate:value() then
				hungerrate = self.owner.medal_hungerrate:value()
			end
		end
		if hungerrate>1 then
			if hungerrate>=3 then--大箭头下降
				anim = "arrow_loop_decrease_most" 
			elseif hungerrate>=2 then
				anim = "arrow_loop_decrease_more" 
			elseif hungerrate>1 then
				anim = "arrow_loop_decrease"
			end
			if self.arrowdir ~= anim then
				self.arrowdir = anim
				self.hungerarrow:GetAnimState():PlayAnimation(anim, true)
			end
		elseif oldOnUpdate then
			oldOnUpdate(self)
		end
	end
end
AddClassPostConstruct( "widgets/hungerbadge", hungerDownAnim)

--受到蜂毒伤害的界面效果
AddClassPostConstruct("screens/playerhud",function(inst)
	local MedalInjured = require("widgets/medal_injured")
	local oldCreateOverlays =inst.CreateOverlays
	function inst:CreateOverlays(owner)
		oldCreateOverlays(self, owner)
		self.medal_injured = self.overlayroot:AddChild(MedalInjured(owner))
	end
end)

---------------------------------------------------------------------------------------------------------
-----------------------------------------------勋章栏----------------------------------------------------
---------------------------------------------------------------------------------------------------------

--加入勋章栏，代码参考了五格装备栏Mod
if TUNING.ADD_MEDAL_EQUIPSLOTS then
	local Inv = require "widgets/inventorybar"
	local Widget = require "widgets/widget"

	if GLOBAL.EQUIPSLOTS then
		GLOBAL.EQUIPSLOTS["MEDAL"]="medal"
	else
		GLOBAL.EQUIPSLOTS=
		{
			HANDS = "hands",
			HEAD = "head",
			BODY = "body",
			MEDAL = "medal",
		}
	end
	GLOBAL.EQUIPSLOT_IDS = {}
	local slot = 0--装备栏格子数量
	for k, v in pairs(GLOBAL.EQUIPSLOTS) do
		slot = slot + 1
		GLOBAL.EQUIPSLOT_IDS[v] = slot
	end
	-- slot = nil

	AddGlobalClassPostConstruct("widgets/inventorybar", "Inv", function(self)
		local W = 68
		local SEP = 12
		local INTERSEP = 28
		local Inv_Refresh_base = Inv.Refresh or function() return "" end
		local Inv_Rebuild_base = Inv.Rebuild or function() return "" end
		
		self.medal_inv=self.root:AddChild(Widget("medal_inv"))
		self.medal_inv:SetScale(1.5, 1.5)
		
		--获取total_w
		local function getTotalW(self)
			local inventory = self.owner.replica.inventory
			local num_slots = inventory:GetNumSlots()
			local num_equip = #self.equipslotinfo
			local num_buttons = self.controller_build and 0 or 1
			local num_slotintersep = math.ceil(num_slots / 5)
			local num_equipintersep = num_buttons > 0 and 1 or 0
			local total_w = (num_slots + num_equip + num_buttons) * W + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP + (num_slotintersep + num_equipintersep) * INTERSEP
			local x=(W - total_w) * .5 + num_slots * W + (num_slots - num_slotintersep) * SEP + num_slotintersep * INTERSEP
			return total_w,x
		end
		--设置融合勋章栏位置
		local function setMedalInv(self,do_integrated_backpack)
			local total_w,x=getTotalW(self)
			local medal_inv_y = do_integrated_backpack and 80 or 40
			for k, v in ipairs(self.equipslotinfo) do
				if v.slot == EQUIPSLOTS.MEDAL then
					self.medal_inv:SetPosition(x, medal_inv_y, 0)
				end
				x = x + W + SEP
			end
		end
		--加载勋章栏
		function Inv:LoadMedalSlots()
			self.bg:SetScale(1.3+(slot-4)*0.05,1,1.25)--根据格子数量缩放装备栏
			self.bgcover:SetScale(1.3+(slot-4)*0.05,1,1.25)

			if self.addmedalslots == nil then
				self.addmedalslots = 1

				self:AddEquipSlot(GLOBAL.EQUIPSLOTS.MEDAL, "images/medal_equipslots.xml", "medal_equipslots.tex")

				if self.inspectcontrol then
					local total_w,x=getTotalW(self)
					self.inspectcontrol.icon:SetPosition(-4, 6)
					self.inspectcontrol:SetPosition((total_w - W) * .5 + 3, -6, 0)
				end
			end
		end
		--刷新函数
		function Inv:Refresh()
			Inv_Refresh_base(self)
			self:LoadMedalSlots()
		end
		--构建函数
		function Inv:Rebuild()
			Inv_Rebuild_base(self)
			self:LoadMedalSlots()
			local inventory = self.owner.replica.inventory
			local overflow = inventory:GetOverflowContainer()
			overflow = (overflow ~= nil and overflow:IsOpenedBy(self.owner)) and overflow or nil
			local do_integrated_backpack = overflow ~= nil and self.integrated_backpack
			setMedalInv(self,do_integrated_backpack)
		end
	end)
end


---------------------------------------------------------------------------------------------------------
---------------------------------------------容器整理功能-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--按字母排序
local function cmp(a,b)
   if a and b then
	   a = tostring(a.prefab)
	   b = tostring(b.prefab)
	   local patt = '^(.-)%s*(%d+)$'
	   local _,_,col1,num1 = a:find(patt)
	   local _,col2,num2 = b:find(patt)
	   if (col1 and col2) and col1 == col2 then
		  return tonumber(num1) < tonumber(num2)
	   end
	   return a < b
   end
end

--容器排序
local function slotsSort(inst)
	if inst and inst.components.container then
		local keys=table.getkeys(inst.components.container.slots)
		if #keys>0 then
			table.sort(keys)
			for k,v in ipairs(keys) do
				if k~=v then
					local item=inst.components.container:RemoveItemBySlot(v)
					if item then
						inst.components.container:GiveItem(item,k)
					end
				end
			end
		end
		table.sort(inst.components.container.slots,cmp)
		for k,v in ipairs(inst.components.container.slots) do
			local item=inst.components.container:RemoveItemBySlot(k)
			if item then
				inst.components.container:GiveItem(item)
			end
		end
	end
end

-----------------------------------------------------------------------------------------
--需要整理功能的容器
local needSortList={
	"livingroot_chest2",--树根宝箱2
	"livingroot_chest3",--树根宝箱3
	"livingroot_chest4",--树根宝箱4
}
--整理按钮点击函数
local function slotsSortFn(inst, doer)
	if inst.components.container ~= nil then
		slotsSort(inst)
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end
--整理按钮亮起规则
local function slotsSortValidFn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()--容器不为空
end

---------------------------------------------------------------------------------------------------------
---------------------------------------------智能分配功能-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--智能分配
local function autoDistribution(inst)
	if inst and inst.components.container then
		local container=inst.components.container
		local numslots=container:GetNumSlots()--容器格子数
		local item_loot={}--预置物统计表，子表格式:{prefab="xx",first=起始格子,end=终止格子,num=总数量}
		local item_with_num={}--最终效果对照表，子表格式:{prefab="xx",num=该格子拥有数量}
		local prefabname=nil
		
		for i=1,numslots do
			if container.slots[i] then
				--获取堆叠数量
				local stacksize = container.slots[i].components.stackable and container.slots[i].components.stackable:StackSize() or 1
				--预置物名不相等，则进行登记
				if container.slots[i].prefab~=prefabname then
					--上一条数据不为空，则添加终止标记
					if item_loot[#item_loot] then
						item_loot[#item_loot].last=i-1
					end
					prefabname=container.slots[i].prefab
					item_loot[#item_loot+1]={prefab=prefabname,first=i,num=stacksize}--登记
				--预置物名相等，数量相加
				elseif item_loot[#item_loot] then
					item_loot[#item_loot].num=item_loot[#item_loot].num+stacksize
				end
			end
			--最后一个格子自身就是last
			if i>=numslots then
				if item_loot[#item_loot] then
					item_loot[#item_loot].last=i
				end
			end
		end
		--无论如何都从第一个格子算起(这样玩家的自由度反而会降低)
		--[[
		if #item_loot>0 then
			item_loot[1].first=1
		end
		]]
		--根据预置物统计表对预置物进行再分配
		for _,v in ipairs(item_loot) do
			local slotnum=v.last-v.first+1--该预置物所占格子数
			local extra=v.num%slotnum--取余获得多余的种子，依次分发给格子
			for i=v.first,v.last do
				item_with_num[i]={prefab=v.prefab,num=math.floor(v.num/slotnum)+(extra>0 and 1 or 0)}
				extra=extra-1
			end
		end
		
		local all_items=container:RemoveAllItems()--把容器里的预置物都掏出来
		
		for _,v in ipairs(all_items) do
			for i=1,numslots do
				if item_with_num[i] and v.prefab==item_with_num[i].prefab and item_with_num[i].num>0 then
					local stacksize=v.components.stackable and v.components.stackable:StackSize() or 1
					if stacksize>1 and stacksize>item_with_num[i].num then
						local item = v.components.stackable:Get(item_with_num[i].num)
						if item then
							container:GiveItem(item,i)
							item_with_num[i].num=0
						end
					else
						container:GiveItem(v,i)
						item_with_num[i].num=item_with_num[i].num-stacksize
						break
					end
				end
			end
		end
	end
end

--一键分配按钮点击函数
local function autoDistributionFn(inst, doer)
	if inst.components.container ~= nil then
		autoDistribution(inst)
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end
--一键分配按钮亮起规则
local function autoDistributionValidFn(inst)
	return inst.replica.container ~= nil and not inst.replica.container:IsEmpty()--容器不为空
end

---------------------------------------------------------------------------------------------------------
-----------------------------------------------新容器----------------------------------------------------
---------------------------------------------------------------------------------------------------------

--容器默认坐标
local default_pos={
	bearger_chest = Vector3(0, 220, 0),--熊皮宝箱
	medal_toy_chest = Vector3(0, 220, 0),--玩具箱
	medal_childishness_chest = Vector3(0, 280, 0),--童心箱
	medal_krampus_chest = Vector3(0, 220, 0),--坎普斯之匣
	medal_krampus_chest_item = Vector3(-275, -50, 0),--坎普斯之匣
	medal_ice_machine = Vector3(200, 0, 0),--制冰机
	livingroot_chest1 = Vector3(0, 200, 0),--树根宝箱第1阶段
	livingroot_chest2 = Vector3(0, 200, 0),--树根宝箱第2阶段
	livingroot_chest3 = Vector3(0, 200, 0),--树根宝箱第3阶段
	livingroot_chest4 = Vector3(0, 200, 0),--树根宝箱第4阶段
	-- medal_box = Vector3(-140, -70, 0),--勋章盒2*4
	medal_box = Vector3(-140, -50, 0),--勋章盒2*6
	spices_box = Vector3(0, 220, 0),--Vector3(-275, -50, 0),--调料盒2*6
	medal_ammo_box = Vector3(-275, -50, 0),--Vector3(-140, -50, 0),--弹药盒2*6
	medal_farm_plow = Vector3(0, 200, 0),--高效耕地机
	medal_resonator = Vector3(0, 160, 0),--宝藏探测仪
	medal_fishingrod = Vector3(0, 15, 0),--玻璃钓竿
	-- multivariate_certificate = Vector3(400, -280, 0),--融合勋章
	multivariate_certificate = TUNING.MEDAL_INV_SWITCH and Vector3(0, 60, 0) or Vector3(400, -280, 0),--融合勋章
	medium_multivariate_certificate = TUNING.MEDAL_INV_SWITCH and Vector3(0, 80, 0) or Vector3(400, -280, 0),--中级融合勋章
	large_multivariate_certificate = TUNING.MEDAL_INV_SWITCH and Vector3(0, 80, 0) or Vector3(400, -280, 0),--高级融合勋章
}
--熊皮宝箱
local params = {}
params.bearger_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.bearger_chest,
		side_align_tip = 160,
	},
	type = "chest",
}

for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.bearger_chest.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

--玩具箱
params.medal_toy_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.medal_toy_chest,
		side_align_tip = 160,
	},
	acceptsstacks = false,
	type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.medal_toy_chest.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end
--玩具黑名单(节日玩具不可入箱)
local toy_blacklist={}
if HALLOWEDNIGHTS_TINKET_START and HALLOWEDNIGHTS_TINKET_END then
	for i=HALLOWEDNIGHTS_TINKET_START,HALLOWEDNIGHTS_TINKET_END do
		table.insert(toy_blacklist,"trinket_"..i)
	end
end

function params.medal_toy_chest.itemtestfn(container, item, slot)
    return (item.prefab=="antliontrinket" or string.sub(item.prefab,1,8)=="trinket_") and not table.contains(toy_blacklist,item.prefab) and not container:Has(item.prefab,1)
end

--童心箱
params.medal_childishness_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_tacklecontainer_3x5",
		animbuild = "ui_tacklecontainer_3x5",
		pos = default_pos.medal_childishness_chest,
		side_align_tip = 160,
		buttoninfo =
		{
			text = STRINGS.MEDAL_UI.EXCHANGEGIFT,
			position = Vector3(0, -280, 0),
		}
	},
	type = "chest",
}

for y = 1, -2, -1 do
    for x = 0, 2 do
        table.insert(params.medal_childishness_chest.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 45, 0))
    end
end

--点击按钮
function params.medal_childishness_chest.widget.buttoninfo.fn(inst, doer)
	if inst.components.container ~= nil then
		if inst.components.container:IsFull() then
			if inst.exchangeGift then
				inst.exchangeGift(inst,doer)
			end
		end
	elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
		SendRPCToServer(RPC.DoWidgetButtonAction, nil, inst, nil)
	end
end

function params.medal_childishness_chest.widget.buttoninfo.validfn(inst)
	return inst.replica.container ~= nil and inst.replica.container:IsFull()--容器必须被填满
end

--坎普斯之匣
params.medal_krampus_chest = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.medal_krampus_chest,
		side_align_tip = 160,
		dragtype="medal_krampus_chest",--拖拽标签，有则可拖拽
	},
	type = "medal_krampus_chest",
}
--3*4
for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.medal_krampus_chest.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

function params.medal_krampus_chest.itemtestfn(container, item, slot)
    return not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end

params.medal_krampus_chest_item = {
	widget =
	{
		slotpos = {},
		-- animbank = "ui_chester_shadow_3x4",
		-- animbuild = "ui_chester_shadow_3x4",
		animbank = "ui_piggyback_2x6",
		animbuild = "ui_piggyback_2x6",
		pos = default_pos.medal_krampus_chest_item,
		-- side_align_tip = 160,
		dragtype="medal_krampus_chest_item",--拖拽标签，有则可拖拽
	},
	issidewidget = true,
	type = "medal_krampus_chest",
}
--2*6
for y = 0, 5 do
	table.insert(params.medal_krampus_chest_item.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
	table.insert(params.medal_krampus_chest_item.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

function params.medal_krampus_chest_item.itemtestfn(container, item, slot)
    return not (item:HasTag("irreplaceable") or item:HasTag("_container"))
end

--蓝曜石制冰机
params.medal_ice_machine = {
	widget =
	{
		slotpos = {
			Vector3(-37.5, 32 + 4, 0),
			Vector3(37.5, 32 + 4, 0),
			Vector3(-37.5, -(32 + 4), 0),
			Vector3(37.5, -(32 + 4), 0),
		},
		animbank = "ui_chest_2x2",
		animbuild = "ui_chest_2x2",
		pos = default_pos.medal_ice_machine,
		side_align_tip = 160,
		-- dragtype="medal_ice_machine",--拖拽标签，有则可拖拽
	},
	type = "chest",
}
--只能放冰
function params.medal_ice_machine.itemtestfn(container, item, slot)
    return item:HasTag("frozen")
end

--树根宝箱第1阶段
params.livingroot_chest1 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = default_pos.livingroot_chest1,
		side_align_tip = 160,
	},
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(params.livingroot_chest1.widget.slotpos, Vector3(80 * (x - 2) + 80, 80 * (y - 2) + 80, 0))
	end
end

--树根宝箱第2阶段
params.livingroot_chest2 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_medalcontainer_4x4",
		animbuild = "ui_medalcontainer_4x4",
		pos = default_pos.livingroot_chest2,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.SLOTSSORT,
			position = Vector3(0, -190, 0),
			fn=slotsSortFn,
			validfn=slotsSortValidFn,
		}
	},
	type = "chest",
}

for y = 3, 0, -1 do
	for x = 0, 3 do
		table.insert(params.livingroot_chest2.widget.slotpos, Vector3(80 * (x - 2) + 40, 80 * (y - 2) + 40, 0))
	end
end

--树根宝箱第3阶段
params.livingroot_chest3 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_medalcontainer_5x5",
		animbuild = "ui_medalcontainer_5x5",
		pos = default_pos.livingroot_chest3,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.SLOTSSORT,
			position = Vector3(0, -230, 0),
			fn=slotsSortFn,
			validfn=slotsSortValidFn,
		}
	},
	type = "chest",
}

for y = 4, 0, -1 do
	for x = 0, 4 do
		table.insert(params.livingroot_chest3.widget.slotpos, Vector3(80 * (x - 3) + 80, 80 * (y - 3) + 80, 0))
	end
end

--树根宝箱第4阶段
params.livingroot_chest4 = {
	widget =
	{
		slotpos = {},
		animbank = "ui_medalcontainer_5x10",
		animbuild = "ui_medalcontainer_5x10",
		pos = default_pos.livingroot_chest4,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.SLOTSSORT,
			position = Vector3(0, -230, 0),
			fn=slotsSortFn,
			validfn=slotsSortValidFn,
		}
	},
	type = "chest",
}

for y = 4, 0, -1 do
	for x = 0, 9 do
		local offsetX = x<=4 and -20 or 10
		table.insert(params.livingroot_chest4.widget.slotpos, Vector3(80 * (x - 5) + 40+offsetX, 80 * (y - 3) + 80, 0))
	end
end

--勋章盒
params.medal_box = {
	widget =
	{
		slotpos = {},
		animbank = "ui_piggyback_2x6",
		animbuild = "ui_piggyback_2x6",
		pos = default_pos.medal_box,
		-- side_align_tip = 160,
		dragtype="medal_box",--拖拽标签，有则可拖拽
	},
	issidewidget = true,
	type = "medal_box",
}

for y = 0, 5 do
	table.insert(params.medal_box.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
	table.insert(params.medal_box.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

function params.medal_box.itemtestfn(container, item, slot)
    return item:HasTag("medal")
end
params.medal_box.priorityfn = params.medal_box.itemtestfn
-- function params.medal_box.priorityfn(container, item, slot)
--     return item:HasTag("medal")
-- end
--调料盒
params.spices_box = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chester_shadow_3x4",
		animbuild = "ui_chester_shadow_3x4",
		pos = default_pos.spices_box,
		side_align_tip = 160,
		-- dragtype="spices_box",--拖拽标签，有则可拖拽
	},
	-- issidewidget = true,
	type = "chest",
}

--3*4
for y = 2.5, -0.5, -1 do
	for x = 0, 2 do
		table.insert(params.spices_box.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
	end
end

function params.spices_box.itemtestfn(container, item, slot)
    return item:HasTag("spice")
end

--弹药盒
params.medal_ammo_box = {
	widget =
	{
		slotpos = {},
		animbank = "ui_piggyback_2x6",
		animbuild = "ui_piggyback_2x6",
		pos = default_pos.medal_ammo_box,
		-- side_align_tip = 160,
		dragtype="medal_krampus_chest_item",--"medal_box",--拖拽标签，有则可拖拽
	},
	issidewidget = true,
	type = "medal_krampus_chest",--"medal_box",
}

for y = 0, 5 do
	table.insert(params.medal_ammo_box.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
	table.insert(params.medal_ammo_box.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
end

function params.medal_ammo_box.itemtestfn(container, item, slot)
    return item:HasTag("slingshotammo")
end

--高效耕地机
params.medal_farm_plow = {
	widget =
	{
		slotpos = {},
		animbank = "ui_chest_3x3",
		animbuild = "ui_chest_3x3",
		pos = default_pos.medal_farm_plow,
		side_align_tip = 160,
		buttoninfo={
			text = STRINGS.MEDAL_UI.DISTRIBUTION,
			position = Vector3(0, -140, 0),
			fn=autoDistributionFn,
			validfn=autoDistributionValidFn,
		}
	},
	type = "chest",
}

for y = 2, 0, -1 do
	for x = 0, 2 do
		table.insert(params.medal_farm_plow.widget.slotpos, Vector3(80 * (x - 2) + 80, 80 * (y - 2) + 80, 0))
	end
end

function params.medal_farm_plow.itemtestfn(container, item, slot)
    return item:HasTag("deployedfarmplant")
end

--宝藏探测仪
params.medal_resonator =
{
    widget =
    {
        slotpos = {
            Vector3(-2, 18, 0),
        },
		animbank = "ui_alterguardianhat_1x1",
		animbuild = "ui_medalcontainer_1x1",
		pos = default_pos.medal_resonator,
    },
    acceptsstacks = false,
    type = "chest",
}

function params.medal_resonator.itemtestfn(container, item, slot)
    return item.prefab=="medal_treasure_map"--只能放藏宝图
end
--玻璃钓竿
params.medal_fishingrod =
{
	widget =
	{
		slotpos =
		{
			Vector3(0,   32 + 4,  0),
		},
		slotbg =
		{
			{ image = "fishing_slot_lure.tex" },
		},
		animbank = "ui_cookpot_1x2",
		animbuild = "ui_cookpot_1x2",
		pos = default_pos.medal_fishingrod,
	},
	usespecificslotsforitems = true,
	type = "hand_inv",
}

function params.medal_fishingrod.itemtestfn(container, item, slot)
	return item:HasTag("oceanfishing_lure")
end


--融合勋章
params.multivariate_certificate = {
	widget =
	{
		slotpos =
        {
            Vector3(-(64 + 12), 0, 0), 
            Vector3(0, 0, 0),
            Vector3(64 + 12, 0, 0), 
        },
		slotbg =
        {
            { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
            { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
        },
		animbank = "ui_chest_3x1",
		animbuild = "ui_chest_3x1",
		pos = default_pos.multivariate_certificate,
		-- pos = Vector3(0, 60, 0),
		-- side_align_tip = 160,
		hanchor=0,--锚点，0中1左2右
		vanchor=2,--锚点，0中1上2下
		dragtype="multivariate_certificate",--拖拽标签，有则可拖拽
	},
	-- issidewidget = true,
	usespecificslotsforitems = true,--使用特定插槽
	type = "multivariate_certificate",
	-- type = "hand_inv",
}

--检测可放入融合勋章的物品
function params.multivariate_certificate.itemtestfn(container, item, slot)
	--可放入融合勋章并且没有相同的勋章组标签
	return item:HasTag("addfunctional") and not (item.grouptag and container.inst:HasTag(item.grouptag))
end

--中级融合勋章
params.medium_multivariate_certificate = {
	widget =
	{
		slotpos = {
			Vector3(-37.5, 32 + 4, 0),
			Vector3(37.5, 32 + 4, 0),
			Vector3(-37.5, -(32 + 4), 0), 
			Vector3(37.5, -(32 + 4), 0),
		},
		slotbg = {
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
			{ atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" },
		},
		animbank = "ui_chest_2x2",
		animbuild = "ui_chest_2x2",
		pos = default_pos.medium_multivariate_certificate,
		hanchor=0,--锚点，0中1左2右
		vanchor=2,--锚点，0中1上2下
		dragtype="medium_multivariate_certificate",--拖拽标签，有则可拖拽
	},
	usespecificslotsforitems = true,--使用特定插槽
	type = "multivariate_certificate",
}

-- for y = 1, 0, -1 do
--     for x = 0, 2 do
--         table.insert(params.medium_multivariate_certificate.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
--         table.insert(params.medium_multivariate_certificate.widget.slotbg, { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" })
--     end
-- end

--检测可放入融合勋章的物品
function params.medium_multivariate_certificate.itemtestfn(container, item, slot)
	--可放入融合勋章并且没有相同的勋章组标签
	return item:HasTag("addfunctional") and not (item.grouptag and container.inst:HasTag(item.grouptag))
end

--高级融合勋章
params.large_multivariate_certificate = {
	widget =
	{
		slotpos = {},
		slotbg = {},
		animbank = "ui_chest_3x2",
		animbuild = "ui_chest_3x2",
		pos = default_pos.large_multivariate_certificate,
		hanchor=0,--锚点，0中1左2右
		vanchor=2,--锚点，0中1上2下
		dragtype="large_multivariate_certificate",--拖拽标签，有则可拖拽
	},
	usespecificslotsforitems = true,--使用特定插槽
	type = "multivariate_certificate",
}

for y = 1, 0, -1 do
    for x = 0, 2 do
        table.insert(params.large_multivariate_certificate.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 120, 0))
        table.insert(params.large_multivariate_certificate.widget.slotbg, { atlas="images/medal_equip_slot.xml",image = "medal_equip_slot.tex" })
    end
end

--检测可放入融合勋章的物品
function params.large_multivariate_certificate.itemtestfn(container, item, slot)
	--可放入融合勋章并且没有相同的勋章组标签
	return item:HasTag("addfunctional") and not (item.grouptag and container.inst:HasTag(item.grouptag))
end

params.medal_cookpot =
{
    widget =
    {
        slotpos =
        {
            Vector3(0, 64 + 32 + 8 + 4, 0),
            Vector3(0, 32 + 4, 0),
            Vector3(0, -(32 + 4), 0),
            Vector3(0, -(64 + 32 + 8 + 4), 0),
        },
        animbank = "ui_cookpot_1x4",
        animbuild = "ui_cookpot_1x4",
        pos = Vector3(200, 0, 0),
        side_align_tip = 100,
        buttoninfo =
        {
            text = STRINGS.ACTIONS.COOK,
            position = Vector3(0, -165, 0),
        }
    },
    acceptsstacks = false,
    type = "cooker",
}

local cooking = require("cooking")

function params.medal_cookpot.itemtestfn(container, item, slot)
    return cooking.IsCookingIngredient(item.prefab) and not container.inst:HasTag("burnt")
end

function params.medal_cookpot.widget.buttoninfo.fn(inst,doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.COOK):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendRPCToServer(RPC.DoWidgetButtonAction, ACTIONS.COOK.code, inst, ACTIONS.COOK.mod_name)
    end
end

function params.medal_cookpot.widget.buttoninfo.validfn(inst)
    return inst.replica.container ~= nil and inst.replica.container:IsFull()
end

--加入容器
local containers = require "containers"
for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

local containers_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local t = data or params[prefab or container.inst.prefab]
    if t~=nil then
        for k, v in pairs(t) do
			container[k] = v
		end
		container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        return containers_widgetsetup(container, prefab, data)
    end
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------容器拖拽---------------------------------------------------
---------------------------------------------------------------------------------------------------------
--获取拖拽坐标
local function GetDragTypePos(dragtype)
	local medaldargpos = nil
	if ThePlayer and ThePlayer.medal_drag_pos then
		medaldargpos=ThePlayer.medal_drag_pos:value()
	end
	if medaldargpos == nil then
		return
	end
	local i = string.find(medaldargpos,dragtype,1,true)
	if i == nil then
		return
	end
	local allpos = string.split(medaldargpos, ";")--所有坐标
	for _,v in ipairs(allpos) do
		if string.find(v,dragtype,1,true) then
			local posinfo = string.split(v, ",")--坐标信息
			return Vector3(posinfo[2], posinfo[3], posinfo[4])
		end
	end
	return 
end
--拖拽坐标，局部变量存储，减少主客交互
local dragpos={}
--更新同步拖拽坐标(如果容器没打开过，那么存储的坐标信息就没被赋值到dragpos里，这时候直接去存储就会导致之前存储的数据缺失，所以要主动取一下数据存到dragpos里)
local function RefreshDragPos()
	local medaldargpos = nil
	if ThePlayer and ThePlayer.medal_drag_pos then
		medaldargpos=ThePlayer.medal_drag_pos:value()
	end
	if medaldargpos and medaldargpos~="" then
		-- print(medaldargpos)
		local allpos = string.split(medaldargpos, ";")--所有坐标
		for _,v in ipairs(allpos) do
			local posinfo = string.split(v, ",")--坐标信息
			if posinfo[1] and dragpos[posinfo[1]]==nil then
				dragpos[posinfo[1]]=Vector3(posinfo[2], posinfo[3], posinfo[4])
			end
		end
	end
	
end
--记录拖拽坐标
local function SetDragTypePos()
	RefreshDragPos()
	local medal_drag_pos=""
	if next(dragpos) then
		for k,v in pairs(dragpos) do
			medal_drag_pos = medal_drag_pos..k..","..v.x..","..v.y..","..v.z..";"
		end
	end
	if medal_drag_pos~="" then
		medal_drag_pos= string.sub(medal_drag_pos,1,-2)
		SendModRPCToServer(MOD_RPC.functional_medal.SetDragPos, medal_drag_pos)
	end
end

--设置UI可拖拽
local function MakeMedalDragableUI(self,dragtype)
	--添加拖拽提示
	if TUNING.MEDAL_CONTAINERDRAG_SWITCH and self.bganim then
		self.bganim:SetTooltip(STRINGS.MEDAL_UI.DRAGABLETIPS1..string.sub(TUNING.MEDAL_CONTAINERDRAG_SWITCH,-2)..STRINGS.MEDAL_UI.DRAGABLETIPS2)
	end
	
	--修改鼠标控制
	local oldOnControl=self.OnControl
	self.OnControl = function (self,control, down)
		-- 按下热键可拖动
		if TheInput:IsKeyDown(GLOBAL[TUNING.MEDAL_CONTAINERDRAG_SWITCH or "KEY_F1"]) then 
			self:Passive_OnControl(control, down)
		end
		return oldOnControl(self,control,down)
	end
	
	self:MoveToBack()
	--被控制(控制状态，是否按下)
	function self:Passive_OnControl(control, down)
		if control == CONTROL_ACCEPT then
			if down then
				self:StartDrag()
			else
				self:EndDrag()
			end
		end
	end
	--设置拖拽坐标
	function self:SetDragPosition(x, y, z)
		local pos
		if type(x) == "number" then
			pos = Vector3(x, y, z)
		else
			pos = x
		end
		self:SetPosition(pos + self.dragPosDiff)
		if dragtype then
			dragpos[dragtype]=pos + self.dragPosDiff--记录记录拖拽后坐标
		end
	end
	
	--开始拖动
	function self:StartDrag()
		if not self.followhandler then
			local mousepos = TheInput:GetScreenPosition()
			self.dragPosDiff = self:GetPosition() - mousepos
			self.followhandler = TheInput:AddMoveHandler(function(x,y)
				self:SetDragPosition(x,y,0)
				--松开按键停止拖拽
				if not TheInput:IsKeyDown(GLOBAL[TUNING.MEDAL_CONTAINERDRAG_SWITCH or "KEY_F1"]) then 
					self:EndDrag()
				end 
			end)
			self:SetDragPosition(mousepos)
		end
	end
	--停止拖动
	function self:EndDrag()
		if self.followhandler then
			self.followhandler:Remove()
		end
		self.followhandler = nil
		self.dragPosDiff = nil
		self:MoveToBack()
		SetDragTypePos()--保存坐标
	end

	function self:Scale_DoDelta(delta)
		self.scale = math.max(self.scale+delta,0.1)
		self:SetScale(self.scale,self.scale,self.scale)
		self:MoveToBack()
	end
end

GLOBAL.MakeMedalDragableUI=MakeMedalDragableUI

--给容器添加拖拽功能
local function newcontainerwidget(self)
	local oldOpen = self.Open
	self.Open = function(self,...)
		oldOpen(self,...)
		if self.container and self.container.replica.container then
			local widget = self.container.replica.container:GetWidget()
			if widget then	
				--拖拽坐标标签，有则用标签，无则用容器名
				local dragname=widget.dragtype or (TUNING.MEDAL_ALL_CONTAINERDRAG_SWITCH and self.container and self.container.prefab)
				if dragname then
					--设置容器坐标(可装备的容器第一次打开做个延迟，不然加载游戏进来位置读不到)
					if self.container:HasTag("_equippable") and not self.container.isopended then
						self.container:DoTaskInTime(0, function()
							if dragpos[dragname]==nil then
								dragpos[dragname]=GetDragTypePos(dragname)
							end
							local newpos=dragpos[dragname] or default_pos[dragname]
							if newpos then
								self:SetPosition(newpos)
							end
						end)
						self.container.isopended=true
					else
						if dragpos[dragname]==nil then
							dragpos[dragname]=GetDragTypePos(dragname)
						end
						local newpos=dragpos[dragname] or default_pos[dragname]
						if newpos then
							self:SetPosition(newpos)
						end
					end
					--设置可拖拽
					MakeMedalDragableUI(self,dragname)
				end
			end
		end
	end
end
if TUNING.MEDAL_CONTAINERDRAG_SWITCH then
	AddClassPostConstruct("widgets/containerwidget", newcontainerwidget)
end

--重置拖拽坐标
function ResetMedalUIPos()
	dragpos={}
	SendModRPCToServer(MOD_RPC.functional_medal.SetDragPos, "")
end
GLOBAL.ResetMedalUIPos=ResetMedalUIPos

local MedalTownportalScreen = require "screens/medaltownportalscreen"
--添加传送界面
AddClassPostConstruct("screens/playerhud",function(self, anim, owner)
	self.ShowMedalTownportalScreen = function(_, attach)
		if attach == nil then
			return
		else
			self.medaltownportalscreen = MedalTownportalScreen(self.owner, attach)
			self:OpenScreenUnderPause(self.medaltownportalscreen)
			return self.medaltownportalscreen
		end
	end

	self.CloseMedalTownportalScreen = function(_)
		if self.medaltownportalscreen then
			self.medaltownportalscreen:Close()
			self.medaltownportalscreen = nil
		end
	end
end)

--传送塔可书写界面
local writeables = require "writeables"
local SignGenerator = require"signgenerator"
local kinds = {}
kinds["townportal"] = {
    prompt = STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
    middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
            widget:OverrideText( SignGenerator(inst, doer) )
        end, control = CONTROL_MENU_MISC_2 },
    acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },
}
kinds["space_time_certificate"] = {
    prompt = STRINGS.SIGNS.MENU.PROMPT,
    animbank = "ui_board_5x3",
    animbuild = "ui_board_5x3",
    menuoffset = Vector3(6, -70, 0),

    cancelbtn = { text = STRINGS.SIGNS.MENU.CANCEL, cb = nil, control = CONTROL_CANCEL },
    middlebtn = { text = STRINGS.SIGNS.MENU.RANDOM, cb = function(inst, doer, widget)
            widget:OverrideText( SignGenerator(inst, doer) )
        end, control = CONTROL_MENU_MISC_2 },
    acceptbtn = { text = STRINGS.SIGNS.MENU.ACCEPT, cb = nil, control = CONTROL_ACCEPT },
}

local writeables_makescreen = writeables.makescreen

function writeables.makescreen(inst, doer)
    local data = kinds[inst.prefab]
	if data then
		if doer and doer.HUD then
			return doer.HUD:ShowWriteableWidget(inst, data)
		end
	else
		return writeables_makescreen(inst, doer)
	end
end


--------兼容show me的绿色索引，代码来自风铃草大佬的穹妹--------
--如果他优先级比我高 这一段生效
for k,mod in pairs(ModManager.mods) do      --遍历已开启的mod
	if mod and mod.SHOWME_STRINGS then      --因为showme的modmain的全局变量里有 SHOWME_STRINGS 所以有这个变量的应该就是showme
		if mod.postinitfns and mod.postinitfns.PrefabPostInit and mod.postinitfns.PrefabPostInit.treasurechest then     --是的 箱子的寻物已经加上去了
			mod.postinitfns.PrefabPostInit.bearger_chest =  mod.postinitfns.PrefabPostInit.treasurechest--熊皮宝箱
			mod.postinitfns.PrefabPostInit.medal_krampus_chest =  mod.postinitfns.PrefabPostInit.treasurechest--坎普斯之匣
			mod.postinitfns.PrefabPostInit.medal_krampus_chest_item =  mod.postinitfns.PrefabPostInit.treasurechest--坎普斯之匣
			mod.postinitfns.PrefabPostInit.medal_childishness_chest =  mod.postinitfns.PrefabPostInit.treasurechest--童心箱
			mod.postinitfns.PrefabPostInit.medal_box =  mod.postinitfns.PrefabPostInit.treasurechest--勋章盒
			mod.postinitfns.PrefabPostInit.spices_box =  mod.postinitfns.PrefabPostInit.treasurechest--调料盒
			mod.postinitfns.PrefabPostInit.medal_ammo_box =  mod.postinitfns.PrefabPostInit.treasurechest--弹药盒
			mod.postinitfns.PrefabPostInit.medal_livingroot_chest =  mod.postinitfns.PrefabPostInit.treasurechest--树根宝箱
		end
	end
end
--如果他优先级比我低 那下面这一段生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
TUNING.MONITOR_CHESTS.bearger_chest = true--熊皮宝箱
TUNING.MONITOR_CHESTS.medal_krampus_chest = true--坎普斯之匣
TUNING.MONITOR_CHESTS.medal_krampus_chest_item = true--坎普斯之匣
TUNING.MONITOR_CHESTS.medal_childishness_chest = true--童心箱
TUNING.MONITOR_CHESTS.medal_box = true--勋章盒
TUNING.MONITOR_CHESTS.spices_box = true--调料盒
TUNING.MONITOR_CHESTS.medal_ammo_box = true--弹药盒
TUNING.MONITOR_CHESTS.medal_livingroot_chest = true--树根宝箱

--多列展示制作栏
if TUNING.MEDAL_NEW_CRAFTTABS_SWITCH then
	AddClassPostConstruct("widgets/tabgroup", function(self)
		--显示制作栏
		local oldShowTab=self.ShowTab
		self.ShowTab = function(self,tab)
			--有行号且行号超过1，则对tab的隐藏坐标偏移值进行增值
			if tab.colnum and tab.colnum>1 then
				if not self.shown[tab] then
					if self.base_pos[tab] then
						tab:MoveTo((self.base_pos[tab] + self.hideoffset*tab.colnum), self.base_pos[tab], .33)
						self.shown[tab] = true
						if self.onshowtab ~= nil then
							self.onshowtab()
						end
					end
				end
			else
				oldShowTab(self,tab)
			end
		end
		--隐藏制作栏
		local oldHideTab=self.HideTab
		self.HideTab = function(self,tab)
			--有行号且行号超过1，则对tab的隐藏坐标偏移值进行增值
			if tab.colnum and tab.colnum>1 then
				if self.shown[tab] then
					if self.base_pos[tab] then
						tab:MoveTo(self.base_pos[tab], (self.base_pos[tab] + self.hideoffset*tab.colnum), .33)
						self.shown[tab] = false
						if self.onhidetab ~= nil then
							self.onhidetab()
						end
					end
				end
			else
				oldHideTab(self,tab)
			end
		end
	end)
	
	AddClassPostConstruct("widgets/crafttabs", function(self)
		local colmaxtab=1--一列最多有多少个tab(一般是12个，如果有其他Mod插入制作栏也能智能扩增)
		local fistcolmaxtab=0--最左边这列总共有多少个tab(包括叠在一起的部分)
		for k, v in pairs(RECIPETABS) do
			if not v.crafting_station then
				colmaxtab = colmaxtab + 1
			end
			fistcolmaxtab = fistcolmaxtab + 1
		end
		local numtabs = 0--总tab数(不算隐藏的)
		local alltabs = 0--总tab数(包括隐藏的)
		for i, v in ipairs(self.tabs.tabs) do
		    if not v.collapsed then
		        numtabs = numtabs + 1
		    end
			alltabs = alltabs + 1
		end
		local col_numtabs=math.min(numtabs,colmaxtab)--每列tab数
		local spacing = 790/col_numtabs--math.max(790/col_numtabs,self.tabs.spacing)
		local scalar = spacing * (1 - col_numtabs) * .5
		local offset = self.tabs.offset * scalar
		local offsetx = Vector3(50, 0, 0)--x坐标修正
		--------------这里由于显示层级问题，所以需要排序在前面的靠右显示，从右往左依次排列
		local maxcol=math.ceil(numtabs/colmaxtab)--最大列数
		local maxcol_correct=colmaxtab*maxcol-numtabs--最右列数值校正
		local newpos=offset--新坐标
		local controllercrafting_tabidx = alltabs - fistcolmaxtab + 1--键盘制作栏默认制作栏编号(默认都放到工具栏上)
		-- print("默认编号:"..controllercrafting_tabidx..",总数:"..alltabs..",第一列数:"..fistcolmaxtab)
		for _, v in ipairs(self.tabs.tabs) do
		    --不是隐藏的才需要更新新坐标，否则都输出在同一个位置
			if not v.collapsed then
				newpos=offset--每次都要重置下，避免叠加数值
				local colnum=math.ceil(numtabs/colmaxtab)--当前列
				if colnum<maxcol then
					maxcol_correct=0--当前列小于最大列，则取消数值校正
				end
				local rownum=(colmaxtab*colnum-numtabs)%colmaxtab-maxcol_correct--当前行
				--根据行号列号进行坐标计算
				newpos = offset + self.tabs.offset*spacing*rownum + offsetx*(colnum-1)
				v.colnum=colnum--记录行号
				numtabs=numtabs-1
			end
		    v:SetPosition(newpos)
		    self.tabs.base_pos[v] = Vector3(newpos:Get())
		end
		self.bg:SetScale(1,1,1)--防止其他mod把它拉长
		self.bg_cover:SetScale(1,1,1)--防止其他mod把它拉长
		self.bg:SetPosition(48,0,0)--背景图往外拉
		self.crafting.in_pos=Vector3(188,0,0)--鼠标制作栏往外拉
		self.controllercrafting.in_pos=Vector3(600,250,0)--键盘制作栏往外拉
		self.controllercrafting.tabidx=controllercrafting_tabidx--设置键盘制作栏默认制作栏编号
	end)
end

local Image = require "widgets/image"

AddClassPostConstruct("widgets/redux/cookbookpage_crockpot", function(self)
	local base_size = 128
	local cell_size = 73
	local icon_size = 20 / (cell_size/base_size)
	if self.recipe_grid then
		--添加标记
		local splist=self.recipe_grid:GetListWidgets()
		if splist and #splist>0 then
			for k,v in pairs(splist) do
				-- v.medal_icon = v.recipie_root:AddChild(Image("images/quagmire_recipebook.xml", "cookbook_unknown_icon.tex"))
				v.medal_icon = v.recipie_root:AddChild(Image("images/quagmire_recipebook.xml", "coin1.tex"))
				v.medal_icon:ScaleToSize(icon_size, icon_size)
				v.medal_icon:SetPosition(-base_size/2 + 105, base_size/2 -25)
				-- v.medal_icon:Show()
			end
		end
		--获取玩家料理列表
		local food_list--料理列表
		if ThePlayer and ThePlayer.medal_food_list then
			local foodstr=ThePlayer.medal_food_list:value()
			if foodstr and #foodstr>0 then
				food_list = string.split(foodstr, ",")--所有坐标
			end
		end
		--hook数据应用函数
		local oldupdate_fn=self.recipe_grid.update_fn
		self.recipe_grid.update_fn=function(context, widget, data, index)
			if oldupdate_fn then
				oldupdate_fn(context, widget, data, index)
			end
			local showmedal=false--是否显示勋章标记
			--这里可以拿到料理数据了，根据勋章数据决定是否显示
			if widget and widget.data and widget.data.prefab then
				-- print(widget.data.prefab)
				if food_list and #food_list>0 then
					if table.contains(food_list,widget.data.prefab) then
						showmedal=true
					end
				end
			end
			if widget and widget.medal_icon then
				if showmedal then
					widget.medal_icon:Show()
				else
					widget.medal_icon:Hide()
				end
			end
		end
		self.recipe_grid:RefreshView()--打开的时候更新一下数据
	end
end)