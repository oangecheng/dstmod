--[[
-----actions-----自定义动作
{
	id,--动作ID
	str,--动作显示名字
	fn,--动作执行函数
	actiondata,--其他动作数据，诸如strfn、mindistance等，可参考actions.lua
	state,--关联SGstate,可以是字符串或者函数
	canqueuer,--兼容排队论 allclick为默认，rightclick为右键动作
}
-----component_actions-----动作和组件绑定
{
	type,--动作类型
		*SCENE--点击物品栏物品或世界上的物品时执行,比如采集
		*USEITEM--拿起某物品放到另一个物品上点击后执行，比如添加燃料
		*POINT--装备某手持武器或鼠标拎起某一物品时对地面执行，比如植物人种田
		*EQUIPPED--装备某物品时激活，比如装备火把点火
		*INVENTORY--物品栏右键执行，比如吃东西
	component,--绑定的组件
	tests,--尝试显示动作，可写多个绑定在同一个组件上的动作及尝试函数
}
-----old_actions-----修改老动作
{
	switch,--开关，用于确定是否需要修改
	id,--动作ID
	actiondata,--需要修改的动作数据，诸如strfn、fn等，可不写
	state,--关联SGstate,可以是字符串或者函数
}
--]]

local MEDAL_FRUIT_TREE_SCION_LOOT = require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_SCION_LOOT--获取接穗掉率表

--使用工具工作
local function DoToolWork(act, workaction)
    if act.target.components.workable ~= nil and
        act.target.components.workable:CanBeWorked() and
        act.target.components.workable:GetWorkAction() == workaction then
        act.target.components.workable:WorkedBy(
            act.doer,
            (   (   act.invobject ~= nil and
                act.invobject.components.tool ~= nil and
                act.invobject.components.tool:GetEffectiveness(workaction)
            ) or
            (   act.doer ~= nil and
                act.doer.components.worker ~= nil and
                act.doer.components.worker:GetEffectiveness(workaction)
            ) or
            1
            ) *
            (   act.doer.components.workmultiplier ~= nil and
                act.doer.components.workmultiplier:GetMultiplier(workaction) or
                1
        )
        )
        return true
    end
    return false
end

--补充耐久(材料,目标,单个材料可增加的耐久)
local function addUseFn(inst,target,adduse)
	local uses = target.components.finiteuses and target.components.finiteuses:GetUses()--当前耐久
	local total = target.components.finiteuses and target.components.finiteuses.total--耐久上限
	if uses==nil then return end
	adduse=adduse or 1
	if adduse>0 then
		if uses>=total then
			return--耐久达上限了
		end
	elseif adduse<0 then
		total=0--减耐久的话就用0作为上限来计算了
	else
		return
	end
	
	local neednum=math.max(math.floor((total-uses)/adduse),1)--需要消耗的材料数量
	local fuelnum = inst.components.stackable and inst.components.stackable.stacksize or 1--材料数量
	--消耗材料变更耐久
	if fuelnum>neednum then
		inst.components.stackable:SetStackSize(fuelnum-neednum)
		target.components.finiteuses:SetUses(math.min(uses+neednum*adduse,target.components.finiteuses.total))
		if target.addusefn then--扩展回调
			target:addusefn(inst,neednum)
		end
	else
		target.components.finiteuses:SetUses(math.min(uses+fuelnum*adduse,target.components.finiteuses.total))
		if target.addusefn then--扩展回调
			target:addusefn(inst,fuelnum)
		end
		inst:Remove()
	end
	return true
end

--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
--移除预制物(预制物,数量)
local function removeItem(item,num)
	if item.components.stackable then
		item.components.stackable:Get(num):Remove()
	else
		item:Remove()
	end
end
--获取可融合勋章升级对象(勋章1,勋章2,玩家)
local function getMultivariateTarget(inst,target,doer)
	local newmedal_loot={
		blank_certificate={
			target="multivariate_certificate",
			tag="traditionalbearer1",
		},
		multivariate_certificate={
			target="medium_multivariate_certificate",
			tag="traditionalbearer2",
		},
		medium_multivariate_certificate={
			target="large_multivariate_certificate",
			tag="traditionalbearer3",
		},
	}
	if inst.prefab ~= target.prefab then
		return
	end
	if newmedal_loot[inst.prefab] and doer:HasTag(newmedal_loot[inst.prefab].tag) then
		return newmedal_loot[inst.prefab].target
	end
end

--自定义动作
local actions = {
	----------------------------INVENTORY道具栏右键----------------------------
	{
		id = "WEARMEDAL",--佩戴勋章
		str = STRINGS.MEDAL_NEWACTION.WEARMEDAL,
		fn = function(act)
			local equipped = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家勋章栏的勋章
			--勋章不存在、勋章栏没勋章、勋章栏的勋章没容器组件则返回false
			if act.invobject == nil or equipped == nil or equipped.components.container == nil or not equipped:HasTag("multivariate_certificate") then
				return false
			end
			
			--获取融合勋章内可装备勋章的格子
			local targetslot = equipped.components.container:GetSpecificMedalSlotForItem(act.invobject)
			if targetslot == nil then
				return false
			end
			--获取融合勋章栏对应格子内的勋章
			local cur_item = equipped.components.container:GetItemInSlot(targetslot)
			--融合勋章格子里没其他勋章
			if cur_item == nil then
				--把勋章放入融合勋章内
				local item = act.invobject.components.inventoryitem:RemoveFromOwner(equipped.components.container.acceptsstacks)
				equipped.components.container:GiveItem(item, targetslot, nil, false)
				-- act.doer:PushEvent("equip", { item = item, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY })
			--融合勋章栏里勋章满了并且最后一格和想放进去的勋章不一样
			-- elseif act.invobject.prefab ~= cur_item.prefab then
			else
				--把勋章放入融合勋章内,并把原来的勋章还给玩家
				local item = act.invobject.components.inventoryitem:RemoveFromOwner(equipped.components.container.acceptsstacks)
				local old_item = equipped.components.container:RemoveItemBySlot(targetslot)
				if not equipped.components.container:GiveItem(item, targetslot, nil, false) then
					act.doer.components.inventory:GiveItem(item)--, nil, equipped:GetPosition())
				end
				if old_item ~= nil then 
					-- act.doer.components.inventory:GiveItem(old_item)--, nil, equipped:GetPosition())
					--切换勋章的时候把勋章放回原位
					if item.prevcontainer ~= nil then
						item.prevcontainer.inst.components.container:GiveItem(old_item, item.prevslot)
					else
						act.doer.components.inventory:GiveItem(old_item, item.prevslot)
					end
				end
				-- act.doer:PushEvent("equip", { item = item, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY })
				return true
			end
			return false
		end,
		actiondata = {
			priority=7,
			rmb=true,
			instant=true,
			mount_valid=true,
			encumbered_valid=true,
		},
	},
	{
		id = "TAKEOFFMEDAL",--摘下勋章
		str = STRINGS.MEDAL_NEWACTION.TAKEOFFMEDAL,
		fn = function(act)
			local equipped = act.doer.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家勋章栏的勋章
			--勋章不存在、勋章栏没勋章、勋章栏的勋章没容器组件则返回false
			if act.invobject == nil or equipped == nil or equipped.components.container == nil or not equipped:HasTag("multivariate_certificate") then
				return false
			end
			
			--如果勋章在融合勋章里，则执行摘下勋章的操作
			if act.invobject.components.inventoryitem:IsHeldBy(equipped) then
				local item = equipped.components.container:RemoveItem(act.invobject)--移除融合勋章中的勋章
				if item ~= nil then
					item.prevcontainer = nil
					item.prevslot = nil
					--勋章还给玩家
					local medal_box=act.doer.components.inventory:FindItem(function(inst)
						if inst:HasTag("medal_box") then
							if inst.components.container and not inst.components.container:IsFull() and inst.replica.container:IsOpenedBy(act.doer) then
								return true
							end
						end
						return false
					end)
					if medal_box then
						medal_box.components.container:GiveItem(item)
					else
						act.doer.components.inventory:GiveItem(item)--, nil, equipped:GetPosition())
					end
					-- act.doer:PushEvent("unequip", { item = item, eslot = EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY})
					return true
				end
			end
			return false
		end,
		actiondata = {
			priority=7,
			rmb=true,
			instant=true,
			mount_valid=true,
			encumbered_valid=true,
		},
	},
	{
		id = "READMEDALTREASUREMAP", --阅读藏宝图
		str = STRINGS.MEDAL_NEWACTION.READMEDALTREASUREMAP,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_treasure_map") then
				local treasure_map = act.doer.components.inventory:RemoveItem(act.invobject)
				local talker = act.doer.components.talker 
				local result=false--生成结果
				if treasure_map then
					if treasure_map.spawnTreasure then
						result=treasure_map.spawnTreasure(treasure_map, act.doer)
					end
					--生成成功，移除藏宝图
					if result then
						treasure_map:Remove()
					else--否则返还藏宝图，并感叹上面的字看不清
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.READMEDALTREASUREMAP_SPEECH.FAIL)
						end
						act.doer.components.inventory:GiveItem(treasure_map)
					end
					return true
				end
				return false
			end
		end,
		state = "doshortaction",
	},
	{
		id = "RELEASEMEDALSOUL", --释放勋章灵魂
		str = STRINGS.MEDAL_NEWACTION.RELEASEMEDALSOUL,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("medal_blinker") and act.invobject ~= nil and act.invobject.prefab == "devour_soul_certificate" and not act.invobject:HasTag("usesdepleted") then
				local fuses = act.invobject.components.finiteuses
				if fuses and fuses:GetUses() > 0 then
					local soul=SpawnPrefab("wortox_soul")
					local x,y,z=act.doer.Transform:GetWorldPosition()
					if soul then
						soul.Transform:SetPosition(x, y, z)
						soul.Physics:Teleport(x, y, z)
						soul.components.inventoryitem:OnDropped(true)
						fuses:Use(1)
					end
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
		},
	},
	{
		id = "BACKTOMEDALTOWER", --回城
		str = STRINGS.MEDAL_NEWACTION.BACKTOMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("space_medal") and act.invobject ~= nil and act.invobject:HasTag("canbacktotower") then
				local fuses = act.invobject.components.finiteuses
				local needuses = TUNING_MEDAL.SPEED_MEDAL.ADDUSES*TUNING_MEDAL.SPEED_MEDAL.CONSUME_MULT--需要消耗耐久
				if fuses and fuses:GetUses() > needuses then
					local target = act.invobject.targetTeleporter--传送目标
					if target and target:IsValid() then
						act.invobject.components.finiteuses:Use(needuses)--扣除耐久
						--执行传送sg
						act.doer.sg:GoToState("medal_entertownportal", { teleporter = target,target=target })
						return true
					else--目标传送点已失效
						act.invobject.targetTeleporter=nil
						act.invobject:RemoveTag("canbacktotower")
						if act.doer.components.talker and not act.doer:HasTag("mime") then
							act.doer.components.talker:Say(STRINGS.DELIVERYSPEECH.CANTFINDTARGET)
						end
						return true
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
		},
	},
	{
		id = "MEDALCOOKBOOK", --阅读食谱书
		str = STRINGS.MEDAL_NEWACTION.MEDALCOOKBOOK,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_cookbook") then
				act.doer:ShowPopUp(POPUPS.COOKBOOK, true)
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
		},
	},
	{
		id = "RELEASEBEEKINGPOWER", --切换蜂王勋章攻击模式
		str = STRINGS.MEDAL_NEWACTION.RELEASEBEEKINGPOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("is_bee_king") and act.invobject ~= nil and act.invobject.prefab == "bee_king_certificate" and not act.invobject:HasTag("usesdepleted") then
				local fuses = act.invobject.components.finiteuses
				if fuses and fuses:GetUses() > 0 then
					--切换勋章攻击模式
					if act.invobject.changeState then
						act.invobject:changeState(not act.invobject.isaoe)
						SpawnPrefab("bee_poof_big").Transform:SetPosition(act.doer.Transform:GetWorldPosition())
						return true
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=8,
		},
	},
	{
		id = "TOUCHSPACEMEDAL", --摸时空勋章
		str = STRINGS.MEDAL_NEWACTION.TOUCHMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("medal_delivery") and act.invobject:HasTag("candelivery") then
				local talker = act.doer.components.talker
				local medal = act.doer.components.inventory and act.doer.components.inventory:EquipMedalWithTag("candelivery")
				if medal then
					if act.invobject.components.medal_delivery then
						act.invobject.components.medal_delivery:OpenScreen(act.doer)
					end
				elseif talker and not act.doer:HasTag("mime") then
					talker:Say(STRINGS.DELIVERYSPEECH.FALSEMEDAL)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "STROKEMEDAL", --摸虫木勋章、植物勋章
		str = STRINGS.MEDAL_NEWACTION.STROKEMEDAL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("canstrokemedal") then
				if act.invobject.strokeFn then
					act.invobject:strokeFn(act.doer)
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "ADDJUSTICE", --快速补充正义值
		str = STRINGS.MEDAL_NEWACTION.ADDJUSTICEVALUE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("addjustice") and act.invobject ~= nil and act.invobject.prefab=="medal_monster_essence" then--act.invobject:HasTag("addjustice") then
				local medal = act.doer.components.inventory and act.doer.components.inventory:EquipMedalWithName("justice_certificate")
				if medal and act.invobject.addjustice_value then
					return addUseFn(act.invobject,medal,act.invobject.addjustice_value)
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	
	----------------------------USEITEM拿起某物品放到另一个物品上点击后执行----------------------------
	{
		id = "GIVEIMMORTAL", --赋予不朽之力
		str = STRINGS.MEDAL_NEWACTION.GIVEIMMORTAL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab == "immortal_gem" and act.target:HasTag("canbeimmortal") and not act.target:HasTag("keepfresh") then
				local talker = act.doer.components.talker
				--获取玩家身上的不朽精华
				local essences = act.doer.components.inventory:FindItems(function(item)
						return item.prefab == "immortal_essence" 
					end)
				local essences_count = 0--不朽精华数量
				for i, v in ipairs(essences) do
					essences_count = essences_count + GetStackSize(v)
				end
				local numslots=act.target.components.container and act.target.components.container.numslots--容器格子数量
				local need_consume=numslots and math.ceil((math.floor(numslots/10)*0.5+1)*numslots)
				if need_consume then
					--玩家身上的不朽精华数量不能少于格子数量(部分容器可跳过该判断)
					if act.target.no_consume_essences or need_consume<=essences_count then
						if act.target.setImmortal then
							act.target.setImmortal(act.target)
							removeItem(act.invobject)
							--部分容器可不消耗
							if not act.target.no_consume_essences then
								--消耗不朽精华
								act.doer.components.inventory:ConsumeByName("immortal_essence",need_consume)
							end
							if talker and not act.doer:HasTag("mime") then
								talker:Say(STRINGS.IMMORTALSPEECH.SUCCESS)
							end
						end
					else
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.IMMORTALSPEECH.NOTENOUGH..need_consume..STRINGS.IMMORTALSPEECH.NOTENOUGH2)
						end
					end
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,--99999,
		},
	},
	{
		id = "GIVESPACEGEM", --赋予空间之力
		str = STRINGS.MEDAL_NEWACTION.GIVESPACEGEM,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab == "medal_space_gem" and (act.target.prefab=="krampus_sack" or act.target.prefab=="space_certificate") then
				local talker = act.doer.components.talker
				local container = act.target.components.inventoryitem ~= nil and act.target.components.inventoryitem:GetContainer() or nil--目标所在容器
				--不能在融合勋章内赋予空间之力
				if container and container.inst:HasTag("multivariate_certificate") then
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
					end
					return true
				end
				if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
					local ismedal = act.target.prefab=="space_certificate"--是否是勋章
					local spawn_at = (container ~= nil and container.inst) or act.target or act.doer--生成点目标
					local newitem = SpawnPrefab(ismedal and "space_time_certificate" or "medal_krampus_chest_item")
					if newitem then
						newitem.Transform:SetPosition(spawn_at.Transform:GetWorldPosition())
						--转移资源
						if not ismedal then
							-- transferEverything(target,newitem)
							--继承不朽之力
							if act.target:HasTag("keepfresh") and newitem.setImmortal then
								newitem:setImmortal()
							end
							--转移资源
							if act.target.components.container and not act.target.components.container:IsEmpty() then
								if newitem.components.container then
									local allitems=act.target.components.container:RemoveAllItemsWithSlot()
									if allitems then
										for k,v in pairs(allitems) do
											newitem.components.container:GiveItem(v,k)
										end
									end
								end
							end
						end
						--目标在容器里，则返还给容器
						if container ~= nil then
							container:GiveItem(newitem, nil, newitem:GetPosition())
						end
						act.invobject:Remove()
						act.target:Remove()
						return true
					end
				else--不能在装备时赋予空间之力
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
					end
					return true
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,--99999,
		},
	},
	{
		id = "CHEFFLAVOUR",--调味
		str = STRINGS.MEDAL_NEWACTION.CHEFFLAVOUR,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("seasoningchef") and act.invobject ~= nil and act.invobject:HasTag("spice") and act.target:HasTag("preparedfood") and not act.target:HasTag("spicedfood") then
				local talker = act.doer.components.talker
				local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
				local container = nil--目标料理所在容器组件
				if owner then
					container = owner.components.inventory or owner.components.container
				end
				
				local newfood=SpawnPrefab(act.target.prefab.."_"..act.invobject.prefab)
				local perishablePercent=nil
				if act.target.components.perishable then
					perishablePercent=act.target.components.perishable:GetPercent()
				end
				if newfood then
					if perishablePercent ~= nil then
						newfood.components.perishable:SetPercent(perishablePercent)
					end
					if not (container and container:GiveItem(newfood)) then
						act.doer.components.inventory:GiveItem(newfood)
					end
					removeItem(act.invobject)
					removeItem(act.target)
				else
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.CHEFFLAVOURSPEECH.FAILFLAVOUR)
					end
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "POWERPRINT",--能力印刻
		str = STRINGS.MEDAL_NEWACTION.POWERPRINT,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject:HasTag("copyfunctional") and act.target:HasTag("blank_certificate") then
				local medalname=act.invobject.prefab
				local medaltag=act.invobject.prefab
				local talker = act.doer.components.talker 
				local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
				if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
					--不能在融合勋章内印刻
					if owner and owner:HasTag("multivariate_certificate") then
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.POWERPRINTSPEECH.ISEQUIPPED)
						end
						return true
					end
					--等级继承
					if act.invobject.medal_level then
						medalname=medalname.."&"..act.invobject.medal_level
					end
					--如果需要印刻的勋章和空白勋章已有的能力不同，则进行印刻
					local oldname=act.target.blankmedalchangename:value() or "blank_certificate"
					if oldname ~= medalname then
						act.target.blankmedalchangename:set(medalname)--换名
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.POWERPRINTSPEECH.SUCCESS)
						end
					else
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.POWERPRINTSPEECH.ALREADY)
						end
					end
				else
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.POWERPRINTSPEECH.ISEQUIPPED)
					end
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "POWERABSORB",--能力吸收
		str = STRINGS.MEDAL_NEWACTION.POWERABSORB,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject:HasTag("blank_certificate") and (act.target.prefab=="statueglommer" or act.target:HasTag("powerabsorbable")) then
				local medal_loot={
					rage_krampus_soul="devour_soul_certificate",--暴怒之灵→噬灵勋章
					amulet="bathingfire_certificate",--重生护符→浴火勋章
					medal_withered_heart="bee_king_certificate",--凋零之心→蜂王勋章
				}
				
				local talker = act.doer.components.talker 
				if act.target:HasTag("powerabsorbable") then
					--羽绒服、蓝晶帽
					if act.target.prefab=="down_filled_coat" or act.target.prefab=="hat_blue_crystal" then
						local iscoat=act.target.prefab=="down_filled_coat"
						local newmedal=SpawnPrefab(iscoat and "down_filled_coat_certificate" or "blue_crystal_certificate")
						if newmedal then
							act.doer.components.inventory:GiveItem(newmedal)
							if act.target.components.fueled then
								act.target.components.fueled:DoDelta(-(iscoat and TUNING_MEDAL.DOWN_FILLED_COAT_MEDAL_PERISHTIME or TUNING_MEDAL.HAT_BLUE_CRYSTAL_MEDAL_PERISHTIME))
							end
							removeItem(act.invobject)
							return true
						end
					elseif medal_loot[act.target.prefab] then
						local newmedal=SpawnPrefab(medal_loot[act.target.prefab])
						if newmedal then
							act.doer.components.inventory:GiveItem(newmedal)
							removeItem(act.target)
							removeItem(act.invobject)
							return true
						end
					end
				else--格罗姆雕像
					if act.invobject.blankmedalchangename:value() ~= "naughty_certificate" then
						act.invobject.blankmedalchangename:set("naughty_certificate")
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.BLANKMEDALSPEECH.GETNAUGHTY)
						end
						return true
					else--重复吸收则直接变成正品
						local newmedal=SpawnPrefab("naughty_certificate")
						if newmedal then
							act.doer.components.inventory:GiveItem(newmedal)
							removeItem(act.invobject)
							return true
						end
					end
				end
			end
		end,
		state = "domediumaction",
	},
	{
		id = "REPAIRNAUGHTYBELL",--修补淘气铃铛
		str = STRINGS.MEDAL_NEWACTION.REPAIRNAUGHTYBELL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and (act.invobject.prefab=="glommerfuel" or act.invobject.prefab=="glommerwings" or (act.invobject.prefab=="glommerflower" and act.invobject:HasTag("show_spoilage"))) and act.target.prefab=="medal_naughtybell" then
				return addUseFn(act.invobject,act.target,1)
			end
		end,
		state = "give",
	},
	--[[
	{
		id = "SEALSPIDER",--封印蜘蛛
		str = STRINGS.MEDAL_NEWACTION.SEALSPIDER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject:HasTag("spider_certificate") and act.target:HasTag("spider") then
				local spidername=act.target.prefab
				local talker = act.doer.components.talker 
				if spidername~="spider" then
					local newmedal=SpawnPrefab(spidername.."_certificate")
					if newmedal~=nil then
						act.doer.components.inventory:GiveItem(newmedal)
						act.invobject:Remove()
						act.target:Remove()
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.SPIDERMEDALSPEECH.SEALSUCCESS)
						end
						return true
					end
				end
			end
		end,
		state = "domediumaction",
	},
	]]
	{
		id = "MEDALUPGRADE",--勋章升级
		str = STRINGS.MEDAL_NEWACTION.MEDALUPGRADE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("upgradablemedal") and act.target:HasTag("upgradablemedal") then
				local isSameMedal = act.invobject.prefab == act.target.prefab--是否是同种勋章
				local talker = act.doer.components.talker 
				if isSameMedal then 
					local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil
					--不能在融合勋章内融合
					if owner and owner:HasTag("multivariate_certificate") then
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
						end
						return true
					end
					if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
						local maxLevel=math.max(act.invobject.medal_level,act.target.medal_level)--取两个勋章的最大等级
						--勋章等级不能超过最大等级
						if maxLevel<act.invobject.medal_level_max then
							local newLevel=math.min(act.invobject.medal_level_max,act.invobject.medal_level+act.target.medal_level)
							act.target.medal_level=newLevel--等级继承
							act.target.changemedallevelname:set(newLevel)--名字变更
							--如果有耐久则融合耐久
							local medal_use1=act.invobject.components.finiteuses and act.invobject.components.finiteuses:GetUses()
							local medal_use2=act.target.components.finiteuses and act.target.components.finiteuses:GetUses()
							if medal_use1 and medal_use2 then
								act.target.components.finiteuses:SetMaxUses(TUNING_MEDAL.SPEED_MEDAL.MAXUSES*newLevel)
								act.target.components.finiteuses:SetUses(medal_use1+medal_use2)
							end
							removeItem(act.invobject)
							if talker and not act.doer:HasTag("mime") then
								talker:Say(STRINGS.MEDALUPGRADESPEECH.SUCCESS)
							end
						else
							if talker and not act.doer:HasTag("mime") then
								talker:Say(STRINGS.MEDALUPGRADESPEECH.ISMAX)
							end
						end
					else
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
						end
					end
				else
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.MEDALUPGRADESPEECH.UNLIKE)
					end
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "REPAIRSTAFF",--补充法杖能量
		str = STRINGS.MEDAL_NEWACTION.REPAIRSTAFF,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.target~=nil and act.target:HasTag("adduseable_staff") and act.target:HasTag("adduse_"..act.invobject.prefab) then
				return addUseFn(act.invobject,act.target,act.target.adduse)
			end
		end,
		state = "give",
	},
	{
		id = "REPAIRDEVOURSTAFF",--补充吞噬法杖能量
		str = STRINGS.MEDAL_NEWACTION.MEDALEATFOOD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.target~=nil and act.target.prefab=="devour_staff" and act.invobject:HasTag("preparedfood") then
				local edible=act.invobject.components.edible
				if edible then
					local addUse=edible.hungervalue*TUNING_MEDAL.DEVOUR_STAFF_HUNGER_RATE+edible.sanityvalue*TUNING_MEDAL.DEVOUR_STAFF_SANITY_RATE+edible.healthvalue*TUNING_MEDAL.DEVOUR_STAFF_HEALTH_RATE
					if addUse>0 then
						return addUseFn(act.invobject,act.target,addUse)
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "MAKECOOLDOWN",--强制冷却
		str = STRINGS.MEDAL_NEWACTION.MAKECOOLDOWN,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("cooldownable") and ((act.target:HasTag("blueflame") and act.target:HasTag("fire")) or act.target.prefab=="staffcoldlight") then
				local newitem=SpawnPrefab(act.invobject.prefab=="lavaeel" and "medal_obsidian" or "medal_blue_obsidian")
				if newitem then
					act.doer.components.inventory:GiveItem(newitem)
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "BOTTLESSOUL",--灵魂装瓶
		str = STRINGS.MEDAL_NEWACTION.BOTTLESSOUL,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="messagebottleempty" and act.target.prefab=="krampus_soul" then
				local newitem=SpawnPrefab("bottled_soul")
				if newitem~=nil then
					act.doer.components.inventory:GiveItem(newitem)
					act.target:Remove()
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
	},
	{
		id = "PLACECHUM",--投放鱼食
		str = STRINGS.MEDAL_NEWACTION.PLACECHUM,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="barnacle" and act.target.prefab=="medal_seapond" then
				local fishable = act.target.components.fishable
				local talker = act.doer.components.talker 
				if fishable then
					--饵力值没满
					if fishable.bait_force and fishable.bait_force<10 then
						--增加饵力值
						fishable.bait_force=math.min(fishable.bait_force+math.random(2,3),TUNING_MEDAL.SEAPOND_MAX_NUM)
						fishable:SetRespawnTime(TUNING_MEDAL.SEAPOND_FISH_RESPAWN_TIME)--设定重生时间
						--鱼不满时开始刷新
						if fishable:GetFishPercent()<1 and not fishable.respawntask then
							fishable:RefreshFish()
						end
						SpawnPrefab("weregoose_splash_less2").entity:SetParent(act.target.entity)
						removeItem(act.invobject)
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.PLACECHUMSPEECH.SUCCESS)
						end
						return true
					else
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.PLACECHUMSPEECH.ENOUGH)
						end
						return true
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "DOINGOLD",--增加勋章熟练度
		str = STRINGS.MEDAL_NEWACTION.DOINGOLD,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.target.medal_addexp_loot and act.invobject ~= nil and act.target.medal_addexp_loot[act.invobject.prefab]~=nil then
				return addUseFn(act.invobject,act.target,act.target.medal_addexp_loot[act.invobject.prefab])
			end
		end,
		state = "give",
	},
	{
		id = "MEDALTRANSPLANT",--月光移植
		str = STRINGS.MEDAL_NEWACTION.MEDALTRANSPLANT,
		fn = function(act)
			DoToolWork(act, ACTIONS.MEDALTRANSPLANT)
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("predig")
                and (inst.sg:HasStateTag("digging") and
                    "dig" or
                    "dig_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	{
		id = "MEDALNORMALTRANSPLANT",--普通移植
		str = STRINGS.MEDAL_NEWACTION.MEDALTRANSPLANT,
		fn = function(act)
			DoToolWork(act, ACTIONS.MEDALNORMALTRANSPLANT)
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("predig")
                and (inst.sg:HasStateTag("digging") and
                    "dig" or
                    "dig_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	{
		id = "MEDALHAMMER",--月光锤锤东西
		str = STRINGS.MEDAL_NEWACTION.MEDALHAMMER,
		fn = function(act)
			DoToolWork(act, ACTIONS.MEDALHAMMER)
			return true
		end,
		state=function(inst)
			return not inst.sg:HasStateTag("prehammer")
                and (inst.sg:HasStateTag("hammering") and
                    "hammer" or
                    "hammer_start")
                or nil
		end,
		actiondata = {
			rmb=true,
		},
		canqueuer = "rightclick",--兼容排队论
	},
	{
		id = "ROOTCHESTLEVELUP",--施肥(树根宝箱、虫木勋章)
		str = STRINGS.MEDAL_NEWACTION.ROOTCHESTLEVELUP,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and (act.invobject.prefab=="compostwrap" or act.invobject.prefab=="spice_poop") and act.target:HasTag("needfertilize") then
				local mult = act.invobject.prefab=="spice_poop" and 0.5 or 1--秘制酱料效益为肥料包的一半
				--升级树根宝箱
				if act.target.levelUpFn then
					act.target:levelUpFn(mult)
					removeItem(act.invobject)
					return true
				--虫木勋章、植物勋章、虫木花施肥
				elseif act.target.prefab=="plant_certificate" or act.target.prefab=="transplant_certificate" or act.target.prefab=="medal_wormwood_flower" then
					local addnum=TUNING_MEDAL.PLANT_MEDAL.FERTILITY*mult
					act.target.medal_fertility=math.min(act.target.medal_fertility and act.target.medal_fertility+addnum or addnum,TUNING_MEDAL.PLANT_MEDAL.FERTILITY)
					removeItem(act.invobject)
					return true
				--移植作物施肥
				elseif act.target:HasTag("medal_transplant") then
					if act.target.AddFertilizeFn then
						act.target:AddFertilizeFn()
						removeItem(act.invobject)
						return true
					end
				end
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "GIVEROOTCHESTLIFE",--树根宝箱复苏
		str = STRINGS.MEDAL_NEWACTION.GIVEROOTCHESTLIFE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_plant_medal") and act.invobject ~= nil and act.invobject.prefab=="reviver" and act.target.prefab=="medal_livingroot_chest" and act.target:HasTag("notalive") then
				if act.target.givelifeFn then
					act.target.givelifeFn(act.target)
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "FISHMOONINWATER",--水中捞月
		str = STRINGS.MEDAL_NEWACTION.FISHMOONINWATER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("groggy") and TheWorld.state.isfullmoon and act.doer.replica.sanity:IsLunacyMode() and act.invobject ~= nil and act.invobject.prefab=="messagebottleempty" and act.target:HasTag("cansalvage") then
				local newitem=SpawnPrefab("bottled_moonlight")
				if newitem~=nil then
					act.doer.components.inventory:GiveItem(newitem)
					removeItem(act.invobject)
					
					act.target.AnimState:OverrideSymbol("reflection_quarter", "moondial_waning_build", "reflection_quarter")
					act.target.AnimState:OverrideSymbol("reflection_half", "moondial_waning_build", "reflection_half")
					act.target.AnimState:OverrideSymbol("reflection_threequarter", "moondial_waning_build", "reflection_threequarter")
					act.target.AnimState:SetLightOverride(0.00)
					act.target.AnimState:PlayAnimation("wane_to_new")--播放水变没的动画
					act.target.Light:Enable(false)--取消光的显示
					act.target.Light:SetRadius(0.00)--设置光半径为0
					act.target:RemoveTag("cansalvage")--取消可打捞标记
					act.target.SoundEmitter:KillSound("loop")--清除声音
					-- act.target.sg:GoToState("next")
					return true
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "WASHFUNCTIONAL",--能力清洗
		str = STRINGS.MEDAL_NEWACTION.WASHFUNCTIONAL,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="bottled_moonlight" and act.target:HasTag("washfunctionalable") then
				local talker = act.doer.components.talker--说话组件
				local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil--获取容器
				if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
					--必须要在容器里清洗
					if owner then
						--不能在融合勋章内清洗
						if owner:HasTag("multivariate_certificate") then
							if talker and not act.doer:HasTag("mime") then
								talker:Say(STRINGS.WASHFUNCTIONALSPEECH.ISEQUIPPED)
							end
							return true
						end
					
						local detergent=act.doer.components.inventory:RemoveItem(act.invobject)--洗涤剂(瓶装月光)
						-- local oldmedal=act.doer.components.inventory:RemoveItem(act.target)--需要被洗的勋章
						local oldmedal=act.target.components.inventoryitem:RemoveFromOwner(false)--需要被洗的勋章
						if detergent and oldmedal then
							local newmedal=SpawnPrefab("blank_certificate")
							if newmedal~=nil then
								if oldmedal.prevcontainer ~= nil then
									--放回原位
									oldmedal.prevcontainer.inst.components.container:GiveItem(newmedal, oldmedal.prevslot)
								else
									act.doer.components.inventory:GiveItem(newmedal)
								end
								detergent:Remove()
								oldmedal:Remove()
								if act.doer.components.inventory then
									--概率返还瓶子，否则破碎成玻璃碎片
									if math.random()<TUNING_MEDAL.BOTTLED_RETURN_RATE then
										local newitem=SpawnPrefab("messagebottleempty")
										if newitem then
											act.doer.components.inventory:GiveItem(newitem)
										end
									else
										local newitem=SpawnPrefab("moonglass")
										if newitem then
											act.doer.components.inventory:GiveItem(newitem)
										end
									end
								end
							else
								act.doer.components.inventory:GiveItem(detergent)
							end
						end
					else--不能在地上清洗
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.WASHFUNCTIONALSPEECH.CANTWASH)
						end
					end
				else--不能在装备时清洗
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.WASHFUNCTIONALSPEECH.ISEQUIPPED)
					end
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "REPAIRSOULS",--补充灵魂
		str = STRINGS.MEDAL_NEWACTION.REPAIRSOULS,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and (act.invobject.prefab=="wortox_soul" or act.invobject.prefab=="spice_soul") and act.target.prefab=="devour_soul_certificate" then
				return addUseFn(act.invobject,act.target)
			end
		end,
		state = "give",
	},
	{
		id = "MAKEMUSHTREE",--变成蘑菇树
		str = STRINGS.MEDAL_NEWACTION.MAKEMUSHTREE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or act.doer:HasTag("inmoonlight")) and act.invobject ~= nil and (act.invobject:HasTag("spore") or act.invobject:HasTag("medal_spore")) and act.target:HasTag("stump") and (act.target.prefab=="livingtree" or act.target.prefab=="livingtree_halloween") then
				local mushtree_spore_list={
					spore_tall="mushtree_tall",
					spore_medium="mushtree_medium",
					spore_small="mushtree_small",
					medal_spore_moon="mushtree_moon"
				}
				if mushtree_spore_list[act.invobject.prefab] then
					local newtree=SpawnPrefab(mushtree_spore_list[act.invobject.prefab])
					if newtree then
						newtree.Transform:SetPosition(act.target.Transform:GetWorldPosition())
						newtree.AnimState:PlayAnimation("change")
						newtree.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_grow_1")
						newtree.AnimState:PushAnimation("idle_loop", true)
						newtree:DoTaskInTime(14 * FRAMES, function(inst)
							if not inst:HasTag("stump") and inst.components.growable then
								inst.components.growable:SetStage(inst.components.growable:GetNextStage())
							end
						end)
						removeItem(act.invobject)
						act.target:Remove()
						return true
					end
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "MODIFYTOWERTEXT",--修改传送塔文字
		str = STRINGS.MEDAL_NEWACTION.MODIFYTOWERTEXT,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="featherpencil" and act.target.prefab=="townportal" then
				if act.target.components.writeable then
					if act.target.components.writeable:IsBeingWritten() then
						return false, "INUSE"
					end
					if CanEntitySeeTarget(act.doer, act.target) then
						act.target.components.writeable:BeginWriting(act.doer)
						removeItem(act.invobject)
						return true
					end
				end
			end
		end,
		state = "domediumaction",
	},
	{
		id = "REPAIRDELIVERYPOWER",--补充速度勋章耐久
		str = STRINGS.MEDAL_NEWACTION.REPAIRDELIVERYPOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="townportaltalisman" and act.target:HasTag("addspacevalue") then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.SPEED_MEDAL.ADDUSES)
			end
		end,
		state = "give",
	},
	{
		id = "MAKEMANDARKPLANT",--曼德拉草种植
		str = STRINGS.MEDAL_NEWACTION.MAKEMANDARKPLANT,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or act.doer:HasTag("inmoonlight")) and act.invobject ~= nil and (act.invobject.prefab=="mandrake" or act.invobject.prefab=="mandrake_seeds") and act.target.prefab=="mound" and not act.target:HasTag("DIG_workable") then
				local mandrake_planted=SpawnPrefab("mandrake_planted")
				if mandrake_planted then
					mandrake_planted.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					removeItem(act.invobject)
					--移除墓碑的子对象，防止墓碑被破坏时报错
					local gravestone=act.target.entity:GetParent()
					if gravestone and gravestone.mound then
						gravestone.mound=nil
					end
					act.target:Remove()
					return true
				end
			end
		end,
		state = "dolongaction",
	},
	{
		id = "GRAFTING_TREE",--嫁接
		str = STRINGS.MEDAL_NEWACTION.GRAFTING_TREE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and act.invobject ~= nil and act.invobject:HasTag("graftingscion") and act.target.prefab=="medal_fruit_tree_stump" then
				local newtree=SpawnPrefab(act.invobject.treename or string.sub(act.invobject.prefab,0,-7))
				if newtree then
					newtree.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					if newtree.components.pickable then
						newtree.components.pickable:MakeEmpty()
					end
					newtree.AnimState:PlayAnimation("change")
					newtree.AnimState:PushAnimation("idle", true)
					act.target:Remove()
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "PUT_IN_THE_SEEDS",--塞入种子
		str = STRINGS.MEDAL_NEWACTION.PUT_IN_THE_SEEDS,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("has_transplant_medal") and act.invobject ~= nil and act.invobject:HasTag("deployedfarmplant") and act.target.prefab=="livinglog" then
				local def=MEDAL_FRUIT_TREE_SCION_LOOT[act.invobject.prefab]--接穗信息表
				local scionprefab=nil--接穗代码
				if def then
					local season = TheWorld.state.season--当前季节
					local chance = def.seasonlist and def.seasonlist[season] and def.season_chance_put or def.chance--接穗掉落概率
					--获得接穗代码
					if chance and math.random()<chance then
						scionprefab=def.product
					end
				else
					scionprefab = math.random()<TUNING_MEDAL.SCION_BANANA_CHANCE and "medal_fruit_tree_banana_scion" or nil
				end
				
				--如果有接穗代码，则生成接穗，必定消耗活木和种子
				if scionprefab then
					local scion=SpawnPrefab(scionprefab)
					if scion then
						act.doer.components.inventory:GiveItem(scion)
						removeItem(act.target)--移除活木
						removeItem(act.invobject)--移除种子
						if act.doer.SoundEmitter ~= nil then--播放活木的惨叫声
							act.doer.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
						end
						return true
					end
				--失败时有概率失去活木
				elseif math.random()<TUNING_MEDAL.SCION_LOSE_LIVINGLOG_CHANCE then
					removeItem(act.target)--移除活木
					removeItem(act.invobject)--移除种子
					if act.doer.SoundEmitter ~= nil then--播放活木的惨叫声
						act.doer.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
					end
					return true
				end
				
				removeItem(act.invobject)--移除种子
				return true
			end
		end,
		state = "domediumaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "GREENGEMPLANT",--埋下绿宝石
		str = STRINGS.MEDAL_NEWACTION.MAKEMANDARKPLANT,--共用文字
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject.prefab=="greengem" and act.target.prefab=="mound" and not act.target:HasTag("DIG_workable") then
				local medal_buried_greengem=SpawnPrefab("medal_buried_greengem")
				if medal_buried_greengem then
					medal_buried_greengem.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					removeItem(act.invobject)
					--移除墓碑的子对象，防止墓碑被破坏时报错
					local gravestone=act.target.entity:GetParent()
					if gravestone and gravestone.mound then
						gravestone.mound=nil
					end
					act.target:Remove()
					return true
				end
			end
		end,
		state = "dolongaction",
	},
	{
		id = "WORMWOODFLOWERPLANT",--种植虫木花
		str = STRINGS.MEDAL_NEWACTION.MAKEMUSHTREE,--共用文字
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and TheWorld.state.isfullmoon and act.invobject ~= nil and act.invobject.prefab=="mandrake_seeds" and act.target.prefab=="medal_buried_greengem" then
				local medal_wormwood_flower=SpawnPrefab("medal_wormwood_flower")
				if medal_wormwood_flower then
					medal_wormwood_flower.Transform:SetPosition(act.target.Transform:GetWorldPosition())
					removeItem(act.invobject)
					act.target:Remove()
					return true
				end
			end
		end,
		state = "dolongaction",
	},
	{
		id = "MEDALSPIKEFUSE",--活性触手尖刺融合
		str = STRINGS.MEDAL_NEWACTION.MEDALUPGRADE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("tentaclemedal") and act.invobject ~= nil and act.invobject.prefab=="medal_tentaclespike" and act.target.prefab=="medal_tentaclespike" then
				local spike_use1=act.invobject.components.finiteuses and act.invobject.components.finiteuses:GetUses()
				local spike_use2=act.target.components.finiteuses and act.target.components.finiteuses:GetUses()
				if spike_use1 and spike_use2 and spike_use2<TUNING_MEDAL.MEDAL_TENTACLESPIKE.MAXUSES then
					act.target.components.finiteuses:SetUses(math.min(spike_use1+spike_use2,TUNING_MEDAL.MEDAL_TENTACLESPIKE.MAXUSES))
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "domediumaction",
	},
	{
		id = "MEDALMAKEVARIATION",--使用变异药水
		str = STRINGS.MEDAL_NEWACTION.MEDALMAKEVARIATION,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_moonglass_potion" and not act.target:HasTag("DECOR") then
				if act.target == nil
					or (not act.target:HasTag("flying") and not TheWorld.Map:IsPassableAtPoint(act.target.Transform:GetWorldPosition()))
					or (act.target.components.burnable ~= nil and (act.target.components.burnable:IsBurning() or act.target.components.burnable:IsSmoldering()))
					or (act.target.components.freezable ~= nil and act.target.components.freezable:IsFrozen())
					or (act.target.components.equippable ~= nil and act.target.components.equippable:IsEquipped()) then
					return false
				end
				if act.invobject.makeVariation then
					return act.invobject.makeVariation(act.invobject,act.target,act.doer)
				end
				return false
			end
		end,
		state = "give",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "MULTIVARIATEUPGRADE",--融合勋章升级
		str = STRINGS.MEDAL_NEWACTION.MEDALUPGRADE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.target ~= nil and getMultivariateTarget(act.invobject,act.target,act.doer) ~= nil then
				local talker = act.doer.components.talker 
				if act.invobject.components.container==nil or (act.invobject.components.container:IsEmpty() and act.target.components.container:IsEmpty()) then
					if act.target.components.equippable and not act.target.components.equippable:IsEquipped() then
						local owner = act.target.components.inventoryitem and act.target.components.inventoryitem.owner or nil--获取容器
						--不能在融合勋章内融合
						if owner and owner:HasTag("multivariate_certificate") then
							if talker and not act.doer:HasTag("mime") then
								talker:Say(STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
							end
							return true
						end
						local newmedal=SpawnPrefab(getMultivariateTarget(act.invobject,act.target,act.doer))
						if newmedal then
							if act.target.prevcontainer ~= nil then
								act.target.prevcontainer.inst.components.container:GiveItem(newmedal, act.target.prevslot)
							else
								act.doer.components.inventory:GiveItem(newmedal, act.target.prevslot)
							end
							act.invobject:Remove()
							act.target:Remove()
							if talker and not act.doer:HasTag("mime") then
								talker:Say(STRINGS.MEDALUPGRADESPEECH.SUCCESS)
							end
						end
					else
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDALUPGRADESPEECH.ISEQUIPPED)
						end
					end
				else
					--里面有东西不能融合
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.MEDALUPGRADESPEECH.NEEDEMPTY)
					end
				end
				return true
			end
		end,
		state = "domediumaction",
		actiondata = {
			priority=10,--99999,
		},
	},
	{
		id = "MEDALPYTREDE",--py交易
		str = STRINGS.MEDAL_NEWACTION.MEDALPYTREDE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="toil_money" and act.target:HasTag("medal_trade") then
				if TheWorld and TheWorld.components.medal_infosave then
					local talker = act.doer.components.talker
					--新月才能Py
					if not TheWorld.state.isnewmoon then
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.EXCHANGEGIFT_SPEECH.NOTNEWMOON)
						end
						return true
					end
					--不能重复py
					if TheWorld.components.medal_infosave:IsPyTraded(act.target,act.doer) then
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.EXCHANGEGIFT_SPEECH.TRADED)
						end
						return true
					end
					--py成功
					TheWorld.components.medal_infosave:DoPyTrade(act.target,act.doer)
					act.invobject:Remove()
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.EXCHANGEGIFT_SPEECH.TRADE)
					end
					return true
				end
			end
		end,
		state = "give",
	},
	{
		id = "MEDALREMOULD",--改造
		str = STRINGS.MEDAL_NEWACTION.MEDALREMOULD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_waterpump_item" and act.target.prefab=="waterpump" then
				local talker = act.doer.components.talker
				local x, y, z = act.target.Transform:GetWorldPosition()
				if TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
					local newwaterpump = SpawnPrefab("medal_waterpump")
					if newwaterpump then
						newwaterpump.Transform:SetPosition(x, y, z)
						newwaterpump:PushEvent("onbuilt")
						act.target:Remove()
						act.invobject:Remove()
					end
				else--不能在非陆地上改造
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.MEDALREMOULD_SPEECH.FAIL)
					end
				end
				return true
			end
		end,
		state = "dolongaction",
	},
	{
		id = "MEDALEADDPOWER",--增加女武神之力
		str = STRINGS.MEDAL_NEWACTION.MEDALEADDPOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.invobject ~= nil and act.invobject:HasTag("sketch") and act.target.prefab=="valkyrie_certificate" then
				local talker = act.doer.components.talker
				local sketchLoot={
					"chesspiece_deerclops_sketch",--巨鹿
					"chesspiece_bearger_sketch",--熊大
					"chesspiece_moosegoose_sketch",--鸭子
					"chesspiece_dragonfly_sketch",--龙蝇
					"chesspiece_malbatross_sketch",--邪天翁
					"chesspiece_crabking_sketch",--帝王蟹
					"chesspiece_toadstool_sketch",--蛤蟆
					"chesspiece_stalker_sketch",--暗影编织者
					"chesspiece_klaus_sketch",--克劳斯
					"chesspiece_beequeen_sketch",--蜂后
					"chesspiece_antlion_sketch",--蚁狮
					"chesspiece_minotaur_sketch",--犀牛
					"chesspiece_guardianphase3_sketch",--天体英雄
					"chesspiece_eyeofterror_sketch",--恐怖之眼
					"chesspiece_twinsofterror_sketch",--双子魔眼
				}
				if act.target.valkyrie_power and act.target.valkyrie_power<TUNING_MEDAL.VALKYRIE_MEDAL.MAX_POWER then
					local sketchname=act.invobject.GetSpecificSketchPrefab and act.invobject:GetSpecificSketchPrefab() or nil
					if sketchname and table.contains(sketchLoot, sketchname) then
						act.target.valkyrie_power=act.target.valkyrie_power+1
						act.target:PushEvent("collectsketch")
						act.invobject:Remove()
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDALEADDPOWER_SPEECH.SUCCESS)
						end
					else--图纸不符合条件
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDALEADDPOWER_SPEECH.FAIL)
						end
					end
				else--不能再加了
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.MEDALEADDPOWER_SPEECH.ENOUGH)
					end
				end
				return true
			end
		end,
		state = "give",
	},
	{
		id = "REPAIRFARMPLOW",--打磨犁地机
		str = STRINGS.MEDAL_NEWACTION.REPAIRFARMPLOW,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="flint" and act.target.prefab=="medal_farm_plow_item" then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.MEDAL_FARM_PLOW_ADDUSE)
			end
		end,
		state = "give",
		actiondata = {
			priority=10,--99999,
		},
	},
	{
		id = "BINDINGTOWER",--速度勋章绑定传送塔
		str = STRINGS.MEDAL_NEWACTION.BINDINGTOWER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="space_certificate" and act.target.prefab=="townportal" then
				local talker = act.doer.components.talker
				--原本就已经绑定这个传送塔了
				if act.invobject.targetTeleporter and act.invobject.targetTeleporter == act.target then
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.DELIVERYSPEECH.ALREADYBOUND)
					end
				else
					act.invobject.targetTeleporter = act.target--绑定传送塔
					act.invobject:AddTag("canbacktotower")
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.DELIVERYSPEECH.SUCCESS)
					end
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "FEEDGLOMMER",--给格罗姆喂食
		str = STRINGS.MEDAL_NEWACTION.MEDALEATFOOD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="bananapop_spice_mandrake_jam" and act.target.prefab=="glommer" then
				local talker = act.doer.components.talker
				
				if not act.target.is_diarrhea then
					act.target.is_diarrhea=true
					if act.target.sg then
						act.target.sg:GoToState("bored")
					end
					removeItem(act.invobject)
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.FEEDGLOMMER_SPEECH.SUCCESS)
					end
				else
					if talker and not act.doer:HasTag("mime") then
						talker:Say(STRINGS.FEEDGLOMMER_SPEECH.ENOUGH)
					end
				end
				return true
			end
		end,
		state = "give",
	},
	{
		id = "MEDALREPAIR",--填充修复耐久(fuel组件)
		str = STRINGS.MEDAL_NEWACTION.MEDALREPAIR,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("player") and act.target.medal_repair_loot and act.invobject ~= nil and act.target.medal_repair_loot[act.invobject.prefab]~=nil then
				if act.target.components.fueled and act.target.components.fueled:GetPercent()<1 then
					local currentfuel=act.target.components.fueled.currentfuel--当前耐久
					local maxfuel=act.target.components.fueled.maxfuel--耐久上限
					local addfuel=act.target.medal_repair_loot[act.invobject.prefab]--单个材料可增加的耐久
					local neednum=math.max(math.floor((maxfuel-currentfuel)/addfuel),1)--需要消耗的材料数量
					local fuelnum = act.invobject.components.stackable and act.invobject.components.stackable.stacksize or 1--材料数量
					-- print(currentfuel,maxfuel,addfuel,neednum,fuelnum)
					--消耗材料变更耐久
					if fuelnum>neednum then
						act.invobject.components.stackable:SetStackSize(fuelnum-neednum)
						act.target.components.fueled:DoDelta(neednum*addfuel)
					else
						act.target.components.fueled:DoDelta(fuelnum*addfuel)
						act.invobject:Remove()
					end
					return true
				end
			end
		end,
		state = "give",
	},
	{
		id = "FEEDBEEKINGMEDAL",--给蜂王勋章喂食
		str = STRINGS.MEDAL_NEWACTION.MEDALEATFOOD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="royal_jelly" and act.target.prefab=="bee_king_certificate" then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.BEE_KING_MEDAL.ADDUSE)
			end
		end,
		state = "give",
	},
	{
		id = "MEDALBEEBOXREGEN",--给育王蜂箱补充育王蜂
		str = STRINGS.MEDAL_NEWACTION.MEDALBEEBOXREGEN,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_bee_larva" and act.target.prefab=="medal_beebox" then
				local talker = act.doer.components.talker
				if act.target.components.childspawner then
					if not act.target.components.childspawner:IsFull() then
						act.target.components.childspawner:AddChildrenInside(1)
						removeItem(act.invobject)
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDAL_BEEBOX_SPEECH.NEW)
						end
						return true
					else--装满了
						if talker and not act.doer:HasTag("mime") then
							talker:Say(STRINGS.MEDAL_BEEBOX_SPEECH.FULL)
							return true
						end
					end
				end
			end
		end,
		state = "give",
	},
	{
		id = "MEDALPOLLUTE",--污染血糖
		str = STRINGS.MEDAL_NEWACTION.MEDALPOLLUTE,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("seasoningchef") and act.invobject ~= nil and act.invobject.prefab=="spice_blood_sugar" and act.target.prefab=="rage_krampus_soul" then
				local newspice=SpawnPrefab("spice_rage_blood_sugar")
				if newspice then
					act.doer.components.inventory:GiveItem(newspice)
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "medal_dolongestaction",
		canqueuer = "allclick",--兼容排队论
	},
	{
		id = "ADDJUSTICEVALUE",--补充正义值
		str = STRINGS.MEDAL_NEWACTION.ADDJUSTICEVALUE,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("addjustice") and act.target.prefab=="justice_certificate" then
				return addUseFn(act.invobject,act.target,act.invobject.addjustice_value)
			end
		end,
		state = "give",
	},
	{
		id = "ADDRESONATORFUEL",--补充宝藏探测仪燃料
		str = STRINGS.MEDAL_NEWACTION.ADDRESONATORFUEL,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="charcoal" and act.target.prefab=="medal_resonator_item" then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.MEDAL_RESONATOR_ADDUSE)
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "REPAIRMEDALFISHINGROD",--给玻璃钓竿装线
		str = STRINGS.MEDAL_NEWACTION.REPAIRFISHINGROD,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="silk" and act.target.prefab=="medal_fishingrod" then
				return addUseFn(act.invobject,act.target,TUNING_MEDAL.MEDAL_FISHINGROD.ADDUSE)
			end
		end,
		state = "give",
		actiondata = {
			priority=10,
		},
	},
	{
		id = "MEDALMARKPOS",--时空勋章标记坐标点
		str = STRINGS.MEDAL_NEWACTION.MEDALMARKPOS,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="medal_time_slider" and act.target.prefab=="space_time_certificate" then
				local x,y,z=act.doer.Transform:GetWorldPosition()
				if not TheWorld.Map:IsAboveGroundAtPoint(x, y, z, false) then
					if act.doer.components.talker and not act.doer:HasTag("mime") then
						act.doer.components.talker:Say(STRINGS.DELIVERYSPEECH.ERRORPOS)
					end
					return true
				end
				if act.target.components.medal_delivery then
					if act.target.components.writeable then
						if act.target.components.writeable:IsBeingWritten() then
							return false, "INUSE"
						end
						act.target.components.writeable:BeginWriting(act.doer)
					end
					removeItem(act.invobject)
					return true
				end
			end
		end,
		state = "give",
	},
	{
		id = "MEDALGIVEFIREFLIES",--给藏宝点加萤火虫
		str = STRINGS.MEDAL_NEWACTION.MEDALGIVEFIREFLIES,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="fireflies" and act.target.prefab=="medal_treasure" then
				if act.target.addFireflies and not act.target.ischild then
					act.target:addFireflies()
					removeItem(act.invobject)
					if act.doer.components.talker and not act.doer:HasTag("mime") then
						act.doer.components.talker:Say(STRINGS.EXCHANGEGIFT_SPEECH.ADDFIREFLIES)
					end
				elseif act.doer.components.talker and not act.doer:HasTag("mime") then
					act.doer.components.talker:Say(STRINGS.EXCHANGEGIFT_SPEECH.ADDFIREFLIESFAIL)
				end
				return true
			end
		end,
		state = "give",
	},
	{
		id = "MEDALCHANGEDESTINY",--改命
		str = STRINGS.MEDAL_NEWACTION.MEDALCHANGEDESTINY,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject.prefab=="space_time_certificate" and act.target:HasTag("fate_rewriteable") then
				if act.invobject.timepower and act.invobject.timepower>0 then
					act.invobject.timepower=act.invobject.timepower-1
					act.target.medal_destiny_num=math.random()
					if act.doer.components.talker and not act.doer:HasTag("mime") then
						act.doer.components.talker:Say(STRINGS.CHANGEDESTINYSPEECH.SUCCESS)
					end
				elseif act.doer.components.talker and not act.doer:HasTag("mime") then
					--时间之力不够了
					act.doer.components.talker:Say(STRINGS.CHANGEDESTINYSPEECH.FAIL)
				end
				return true
			end
		end,
		state = "give",
	},
	----------------------------SCENE点击物品----------------------------
	{
		id = "TOUCHMEDALTOWER", --摸塔
		str = STRINGS.MEDAL_NEWACTION.TOUCHMEDALTOWER,
		fn = function(act)
			if act.doer ~= nil and act.doer:HasTag("space_medal") and act.target ~= nil and act.target:HasTag("medal_delivery") then
				local talker = act.doer.components.talker
				local medal = act.doer.components.inventory and act.doer.components.inventory:EquipMedalWithTag("candelivery")
				if medal then
					if act.target.components.medal_delivery then
						act.target.components.medal_delivery:OpenScreen(act.doer)
					end
				elseif talker and not act.doer:HasTag("mime") then
					talker:Say(STRINGS.DELIVERYSPEECH.FALSEMEDAL)
				end
				return true
			end
		end,
		state = "give",
		actiondata = {
			distance=2.1,
			priority=10,--99999,
		},
	},
	{
		id = "MEDALDISMANTLE", --拆除坎普斯宝匣
		str = STRINGS.MEDAL_NEWACTION.MEDALDISMANTLE,
		fn = function(act)
			if act.doer ~= nil and act.target ~= nil and act.target.prefab=="medal_krampus_chest" then
				if act.target.dismantle then
					act.target.dismantle(act.target,act.doer)
				end
				return true
			end
		end,
		state = "domediumaction",
	},
	{
		id = "MEDALSTROKE", --抚摸虫木花
		str = STRINGS.MEDAL_NEWACTION.STROKEMEDAL,
		fn = function(act)
			if act.doer ~= nil and act.target ~= nil and act.target.prefab=="medal_wormwood_flower" then
				if act.target.strokeFn then
					act.target:strokeFn(act.doer)
					return true
				end
			end
		end,
		state = "doshortaction",
	},
	----------------------------EQUIPPED装备物品激活----------------------------
	{
		id = "MEDALPOURWATER", --加水
		str = STRINGS.MEDAL_NEWACTION.MEDALPOURWATER,
		fn = function(act)
			if act.doer ~= nil and act.invobject ~= nil and act.invobject:HasTag("wateringcan") and act.target ~= nil and act.target:HasTag("canpourwater") then
				if act.invobject.components.finiteuses ~= nil then
					if act.invobject.components.finiteuses:GetUses() <= 0 then
						return false, (act.invobject:HasTag("wateringcan") and "OUT_OF_WATER" or nil)
					else
						act.invobject.components.finiteuses:Use()
					end
				end
				if act.target.prefab=="medal_waterpump" then
					if not act.target.candrewwater then
						act.target.candrewwater=true
						act.target.AnimState:PlayAnimation("use_pst")
					end
				elseif act.target.prefab=="medal_ice_machine" then
					if act.target.AddWater then
						act.target:AddWater(2)
					end
				end
				return true
			end
		end,
		state = "pour",
		actiondata = {
			distance=1.5,
		},
	},
}

--动作与组件绑定
local component_actions = {
	{
		type = "INVENTORY",
		component = "inventoryitem",
		tests = {
			{
				action = "WEARMEDAL",--佩戴勋章
				testfn = function(inst,doer,actions,right)
					--如果玩家有库存组件
					if doer.replica.inventory ~= nil then
						local medal_item = doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家勋章栏道具
						--如果勋章栏有勋章，并且勋章有容器，并且容器是由玩家打开的
						if medal_item ~= nil and medal_item:HasTag("multivariate_certificate") and medal_item.replica.container ~= nil and medal_item.replica.container:IsOpenedBy(doer) then
							--如果这个容器可以装勋章
							if medal_item.replica.container:CanTakeItemInSlot(inst) then
								return true
							end
							--如果融合勋章和需要放入的勋章有同样勋章组的标签
							if inst.grouptag~=nil and medal_item:HasTag(inst.grouptag) then
								return true
							end
						end
					end
					return false
				end,
			},
			{
				action = "TAKEOFFMEDAL",--摘下勋章
				testfn = function(inst,doer,actions,right)
					local equipped = (inst ~= nil and doer.replica.inventory ~= nil) and doer.replica.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY) or nil
					if equipped ~= nil and equipped:HasTag("multivariate_certificate") and equipped.replica.container ~= nil and equipped.replica.container:IsHolding(inst) then
						return true
					end
					return false
				end,
			},
			{
				action = "READMEDALTREASUREMAP",--阅读藏宝图
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("player") and inst:HasTag("medal_treasure_map")
				end,
			},
			{
				action = "RELEASEMEDALSOUL",--释放勋章灵魂
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("medal_blinker") and inst.prefab == "devour_soul_certificate" and not inst:HasTag("usesdepleted")
				end,
			},
			{
				action = "BACKTOMEDALTOWER",--回城
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("space_medal") and inst:HasTag("canbacktotower")
				end,
			},
			{
				action = "MEDALCOOKBOOK",--阅读食谱书
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("player") and inst:HasTag("medal_cookbook")
				end,
			},
			{
				action = "RELEASEBEEKINGPOWER",--切换蜂王勋章攻击模式
				testfn = function(inst,doer,actions,right)
					return doer:HasTag("is_bee_king") and inst.prefab == "bee_king_certificate" and not inst:HasTag("usesdepleted")
				end,
			},
			{
				action = "TOUCHSPACEMEDAL",--摸时空勋章
				testfn = function(inst,doer,actions,right)
					return inst:HasTag("medal_delivery") and inst:HasTag("candelivery")
				end,
			},
			{
				action = "STROKEMEDAL",--摸虫木勋章、植物勋章
				testfn = function(inst,doer,actions,right)
					return inst:HasTag("canstrokemedal")
				end,
			},
			{
				action = "ADDJUSTICE",--快速补充正义值
				testfn = function(inst,doer,actions,right)
					-- return doer and doer:HasTag("addjustice") and inst:HasTag("addjustice")
					return doer and doer:HasTag("addjustice") and inst.prefab=="medal_monster_essence"
				end,
			},
		},
	},
	{
		type = "USEITEM",
		component = "inventoryitem",
		tests = {
			{
				action = "GIVEIMMORTAL",--赋予不朽之力
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab == "immortal_gem" and target:HasTag("canbeimmortal") and not target:HasTag("keepfresh")
				end,
			},
			{
				action = "GIVESPACEGEM",--赋予空间之力
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab == "medal_space_gem" and (target.prefab=="krampus_sack" or target.prefab=="space_certificate")
				end,
			},
			{
				action = "CHEFFLAVOUR",--调味
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("seasoningchef") and inst:HasTag("spice") and target:HasTag("preparedfood") and not target:HasTag("spicedfood")
				end,
			},
			{
				action = "POWERPRINT",--能力印刻
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst:HasTag("copyfunctional") and target:HasTag("blank_certificate")
				end,
			},
			{
				action = "REPAIRNAUGHTYBELL",--修补淘气铃铛
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and (inst.prefab=="glommerfuel" or inst.prefab=="glommerwings" or (inst.prefab=="glommerflower" and inst:HasTag("show_spoilage"))) and target.prefab=="medal_naughtybell"
				end,
			},
			--[[
			{
				action = "SEALSPIDER",--封印蜘蛛
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst:HasTag("spider_certificate") and target:HasTag("spider")
				end,
			},
			]]
			{
				action = "POWERABSORB",--能力吸收
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst:HasTag("blank_certificate") and (target.prefab=="statueglommer" or target:HasTag("powerabsorbable"))
				end,
			},
			{
				action = "MEDALUPGRADE",--勋章升级
				testfn = function(inst, doer, target, actions, right)
					return inst:HasTag("upgradablemedal") and target:HasTag("upgradablemedal")
				end,
			},
			{
				action = "REPAIRSTAFF",--补充法杖能量
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and target:HasTag("adduseable_staff") and target:HasTag("adduse_"..inst.prefab)
				end,
			},
			{
				action = "REPAIRDEVOURSTAFF",--补充吞噬法杖能量
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and target.prefab=="devour_staff" and inst:HasTag("preparedfood")
				end,
			},
			{
				action = "MAKECOOLDOWN",--强制冷却
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("expertchef") and inst:HasTag("cooldownable") and ((target:HasTag("blueflame") and target:HasTag("fire")) or target.prefab=="staffcoldlight")
				end,
			},
			{
				action = "BOTTLESSOUL",--灵魂装瓶
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="messagebottleempty" and target.prefab=="krampus_soul"
				end,
			},
			{
				action = "PLACECHUM",--投放鱼食
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="barnacle" and target.prefab=="medal_seapond"
				end,
			},
			{
				action = "DOINGOLD",--增加勋章熟练度
				testfn = function(inst, doer, target, actions, right)
					-- return doer:HasTag("player") and ((inst.prefab=="log" and target:HasTag("chopdoingold")) or ((inst.prefab=="rocks" or inst.prefab=="nitre" or inst.prefab=="flint") and target:HasTag("minedoingold")))
					return target.medal_addexp_loot and target.medal_addexp_loot[inst.prefab]~=nil
				end,
			},
			{
				action = "ROOTCHESTLEVELUP",--施肥(树根宝箱、虫木勋章)
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and (inst.prefab=="compostwrap" or inst.prefab=="spice_poop") and target:HasTag("needfertilize")
				end,
			},
			{
				action = "GIVEROOTCHESTLIFE",--树根宝箱复苏
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_plant_medal") and inst.prefab=="reviver" and target.prefab=="medal_livingroot_chest" and target:HasTag("notalive")
				end,
			},
			{
				action = "FISHMOONINWATER",--水中捞月
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("groggy") and TheWorld.state.isfullmoon and doer.replica.sanity:IsLunacyMode() and inst.prefab=="messagebottleempty" and target:HasTag("cansalvage")
				end,
			},
			{
				action = "WASHFUNCTIONAL",--能力清洗
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="bottled_moonlight" and target:HasTag("washfunctionalable")
				end,
			},
			{
				action = "REPAIRSOULS",--补充灵魂
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and (inst.prefab=="wortox_soul" or inst.prefab=="spice_soul") and target.prefab=="devour_soul_certificate"
				end,
			},
			{
				action = "MAKEMUSHTREE",--变成蘑菇树
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or doer:HasTag("inmoonlight")) and (inst:HasTag("spore") or inst:HasTag("medal_spore")) and target:HasTag("stump") and  (target.prefab=="livingtree" or target.prefab=="livingtree_halloween")
				end,
			},
			{
				action = "MODIFYTOWERTEXT",--修改传送塔文字
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="featherpencil"  and target.prefab=="townportal"
				end,
			},
			{
				action = "REPAIRDELIVERYPOWER",--补充速度勋章耐久
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="townportaltalisman" and target:HasTag("addspacevalue")
				end,
			},
			{
				action = "MAKEMANDARKPLANT",--曼德拉草种植
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and (TheWorld.state.isfullmoon or doer:HasTag("inmoonlight")) and (inst.prefab=="mandrake" or inst.prefab=="mandrake_seeds") and target.prefab=="mound" and not target:HasTag("DIG_workable")
				end,
			},
			{
				action = "GRAFTING_TREE",--嫁接
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and inst:HasTag("graftingscion") and target.prefab=="medal_fruit_tree_stump"
				end,
			},
			{
				action = "PUT_IN_THE_SEEDS",--塞入种子
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("has_transplant_medal") and inst:HasTag("deployedfarmplant") and target.prefab=="livinglog"
				end,
			},
			{
				action = "GREENGEMPLANT",--埋下绿宝石
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="greengem" and target.prefab=="mound" and not target:HasTag("DIG_workable")
				end,
			},
			{
				action = "WORMWOODFLOWERPLANT",--种植虫木花
				testfn = function(inst, doer, target, actions, right)
					return TheWorld.state.isfullmoon and inst.prefab=="mandrake_seeds" and target.prefab=="medal_buried_greengem"
				end,
			},
			{
				action = "MEDALSPIKEFUSE",--活性触手尖刺融合
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("tentaclemedal") and inst.prefab=="medal_tentaclespike" and target.prefab=="medal_tentaclespike"
				end,
			},
			{
				action = "MEDALMAKEVARIATION",--使用变异药水
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="medal_moonglass_potion" and not target:HasTag("DECOR")
				end,
			},
			{
				action = "MULTIVARIATEUPGRADE",--融合勋章升级
				testfn = function(inst, doer, target, actions, right)
					return getMultivariateTarget(inst,target,doer) ~= nil
				end,
			},
			{
				action = "MEDALPYTREDE",--py交易
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="toil_money" and target:HasTag("medal_trade")
				end,
			},
			{
				action = "MEDALREMOULD",--改造
				testfn = function(inst, doer, target, actions, right)
					return inst.prefab=="medal_waterpump_item" and target.prefab=="waterpump"
				end,
			},
			{
				action = "MEDALEADDPOWER",--增加女武神之力
				testfn = function(inst, doer, target, actions, right)
					return inst:HasTag("sketch") and target.prefab=="valkyrie_certificate"
				end,
			},
			{
				action = "REPAIRFARMPLOW",--打磨犁地机
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="flint" and target.prefab=="medal_farm_plow_item"
				end,
			},
			{
				action = "BINDINGTOWER",--空间勋章绑定传送塔
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="space_certificate" and target.prefab=="townportal"
				end,
			},
			{
				action = "FEEDGLOMMER",--给格罗姆喂食
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="bananapop_spice_mandrake_jam" and target.prefab=="glommer"
				end,
			},
			{
				action = "MEDALREPAIR",--填充修复耐久(fuel组件)
				testfn = function(inst, doer, target, actions, right)
					return target.medal_repair_loot and target.medal_repair_loot[inst.prefab]~=nil
				end,
			},
			{
				action = "FEEDBEEKINGMEDAL",--给蜂王勋章喂食
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="royal_jelly" and target.prefab=="bee_king_certificate"
				end,
			},
			{
				action = "MEDALBEEBOXREGEN",--给育王蜂箱补充育王蜂
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="medal_bee_larva" and target.prefab=="medal_beebox"
				end,
			},
			{
				action = "MEDALPOLLUTE",--污染血糖
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("seasoningchef") and inst.prefab=="spice_blood_sugar" and target.prefab=="rage_krampus_soul"
				end,
			},
			{
				action = "ADDJUSTICEVALUE",--补充正义值
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst:HasTag("addjustice") and target.prefab=="justice_certificate"
				end,
			},
			{
				action = "ADDRESONATORFUEL",--补充宝藏探测仪燃料
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="charcoal" and target.prefab=="medal_resonator_item"
				end,
			},
			{
				action = "REPAIRMEDALFISHINGROD",--给玻璃钓竿装线
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="silk" and target.prefab=="medal_fishingrod"
				end,
			},
			{
				action = "MEDALMARKPOS",--时空勋章标记坐标点
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="medal_time_slider" and target.prefab=="space_time_certificate"
				end,
			},
			{
				action = "MEDALGIVEFIREFLIES",--给藏宝点加萤火虫
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="fireflies" and target.prefab=="medal_treasure"
				end,
			},
			{
				action = "MEDALCHANGEDESTINY",--改命
				testfn = function(inst, doer, target, actions, right)
					return doer:HasTag("player") and inst.prefab=="space_time_certificate" and target:HasTag("fate_rewriteable")
				end,
			},
		},
	},
	{
		type = "SCENE",
		component = "workable",
		tests = {
			{
				action = "TOUCHMEDALTOWER",--摸塔
				testfn = function(inst,doer,actions,right)
					return right and doer:HasTag("player") and doer:HasTag("space_medal") and inst:HasTag("medal_delivery")
				end,
			},
			{
				action = "MEDALDISMANTLE",--拆除坎普斯宝匣
				testfn = function(inst,doer,actions,right)
					return right and doer:HasTag("player") and inst ~= nil and inst.prefab=="medal_krampus_chest"
				end,
			},
		},
	},
	{
		type = "SCENE",
		component = "pickable",
		tests = {
			{
				action = "MEDALSTROKE",--抚摸虫木花
				testfn = function(inst,doer,actions,right)
					return right and doer:HasTag("player") and inst ~= nil and inst.prefab=="medal_wormwood_flower"
				end,
			},
		},
	},
	{
		type = "EQUIPPED",
		component = "wateryprotection",
		tests = {
			{
				action = "MEDALPOURWATER",--加水
				testfn = function(inst, doer, target, actions, right)
					return right and doer:HasTag("player") and target:HasTag("canpourwater")
				end,
			},
		},
	},
}

local old_blink_fn=ACTIONS.BLINK.fn
local old_makeballoon_fn=ACTIONS.MAKEBALLOON.fn
local old_cook_fn=ACTIONS.COOK.fn
local old_fish_fn=ACTIONS.FISH.fn

--修改老动作
local old_actions = {
	--采集
	{
		switch = true,--开关
		id = "PICK",
		state = {
			--动作劫持判断(判断是否需特殊处理执行新动作)
			testfn=function(inst, action)
				return inst:HasTag("fastpicker")
			end,
			--根据判断返回具体动作
			deststate=function(inst,action)
				return inst:HasTag("lureplant_rod") and "attack" or "doshortaction"
			end,
		},
	},
	--收获
	{
		switch = true,
		id = "HARVEST",
		state = {
			--动作劫持判断(判断是否需特殊处理执行新动作)
			testfn=function(inst, action)
				return inst:HasTag("fastpicker")
			end,
			--根据判断返回具体动作
			deststate=function(inst,action)
				return inst:HasTag("lureplant_rod") and "attack" or "doshortaction"
			end,
		},
	},
	--拿东西(从眼球草上拿东西)
	{
		switch = true,
		id = "TAKEITEM",
		state = {
			testfn=function(inst, action)
				return inst:HasTag("fastpicker") and action.target~=nil
			end,
			deststate=function(inst,action)
				return inst:HasTag("lureplant_rod") and "attack" or "doshortaction"
			end,
		},
	},
	--种田
	{
		switch = true,
		id = "PLANTSOIL",
		state = {
			testfn=function(inst, action)
				return inst:HasTag("plantkin") 
			end,
			deststate=function(inst,action)
				return "doshortaction"
			end,
		},
	},
	--施法
	{
		switch = true,
		id = "CASTSPELL",
		state = {
			testfn=function(inst, action)
				return action.invobject ~= nil and ((action.invobject:HasTag("medalquickcast") and action.target~=nil) or (action.invobject:HasTag("medalposquickcast") and action:GetActionPoint() ~= nil))
			end,
			deststate=function(inst,action)
				return "quickcastspell"
			end,
		},
	},
	--吹气球
	--[[
	{
		switch = false,
		id = "MAKEBALLOON",
		actiondata = {
			fn = function(act)
				if act.doer ~= nil and
					act.doer:HasTag("has_silence_certificate") and
					act.invobject ~= nil and
					act.invobject.components.balloonmaker ~= nil and
					act.doer:HasTag("balloonomancer") then
					local balloon_type=1--气球类别，0普通，1沉默气球、2暗影气球
					local sanityLoss=3--精神消耗
					if act.doer.components.sanity ~= nil then
						--精神值低于精神消耗的时候，则制作暗影气球
						if act.doer.components.sanity.current < sanityLoss then
							balloon_type=2
						end
						act.doer.components.sanity:DoDelta(-sanityLoss)
					end
					--Spawn it to either side of doer's current facing with some variance
					local x, y, z = act.doer.Transform:GetWorldPosition()
					local angle = act.doer.Transform:GetRotation()
					local angle_offset = GetRandomMinMax(-10, 10)
					angle_offset = angle_offset + (angle_offset < 0 and -65 or 65)
					angle = (angle + angle_offset) * DEGREES
					act.invobject.components.balloonmaker:MakeMedalBalloon(
						x + .5 * math.cos(angle),
						0,
						z - .5 * math.sin(angle),
						balloon_type>1
					)
					return true
				end
				return old_makeballoon_fn(act)
			end,
		},
		state = {
			testfn=function(inst, action)
				return inst:HasTag("has_silence_certificate")
			end,
			deststate=function(inst,action)
				return inst.replica.sanity:IsCrazy() and "doshortaction" or "domediumaction"
			end,
		},
	},
	]]
	--灵魂跳跃
	{
		switch = true,
		id = "BLINK",
		actiondata = {
			strfn = function(act)
				return act.invobject == nil and act.doer ~= nil and (act.doer:HasTag("soulstealer") or act.doer:HasTag("temporaryblinker") or act.doer:HasTag("freeblinker") or act.doer:HasTag("medal_blinker")) and "SOUL" or nil
			end,
			fn = function(act)
				local act_pos = act:GetActionPoint()
				if act.invobject ~= nil then
					if act.invobject.components.blinkstaff ~= nil then
						return act.invobject.components.blinkstaff:Blink(act_pos, act.doer)
					end
				--临时穿梭者
				elseif act.doer ~= nil
					and act.doer:HasTag("temporaryblinker")
					and act.doer.sg ~= nil
					and act.doer.sg.currentstate.name == "portal_jumpin_pre"
					and act_pos ~= nil then
					act.doer:RemoveTag("temporaryblinker")
					act.doer.sg:GoToState("portal_jumpin", act_pos)
					return true
				--自由穿梭者
				elseif act.doer ~= nil
					and act.doer:HasTag("freeblinker")
					and act.doer.sg ~= nil
					and act.doer.sg.currentstate.name == "portal_jumpin_pre"
					and act_pos ~= nil then
					act.doer.sg:GoToState("portal_jumpin", act_pos)
					return true
				--勋章穿梭者
				elseif act.doer ~= nil
					and act.doer:HasTag("medal_blinker")
					and act.doer.sg ~= nil
					and act.doer.sg.currentstate.name == "portal_jumpin_pre"
					and act_pos ~= nil then
					act.doer.sg:GoToState("portal_jumpin", act_pos)
					act.doer:PushEvent("medal_blink")
					return true
				end
				return old_blink_fn(act)
			end,
		},
		state = {
			testfn=function(inst, action)
				return action.invobject == nil and (inst:HasTag("temporaryblinker") or inst:HasTag("freeblinker") or inst:HasTag("medal_blinker"))
			end,
			deststate=function(inst,action)
				return "portal_jumpin_pre"
			end,
		},
	},
	--烹饪
	{
		switch = true,
		id = "COOK",
		actiondata = {
			fn = function(act)
				if act.doer and act.doer:HasTag("seasoningchef") and act.target.components.cooker then
					local stacksize=act.invobject.components.stackable and act.invobject.components.stackable:StackSize() or 1
					local cook_pos = act.target:GetPosition()
					local cooknum=0
					for i=1,stacksize do
						if act.target and act.target:IsValid() then
							local ingredient = act.doer.components.inventory:RemoveItem(act.invobject)
							ingredient.Transform:SetPosition(cook_pos:Get())

							if not act.target.components.cooker:CanCook(ingredient, act.doer) then
								act.doer.components.inventory:GiveItem(ingredient, nil, cook_pos)
							end

							if ingredient.components.health ~= nil and ingredient.components.combat ~= nil then
								act.doer:PushEvent("killed", { victim = ingredient })
							end

							local product = act.target.components.cooker:CookItem(ingredient, act.doer)
							if product ~= nil then
								act.doer.components.inventory:GiveItem(product, nil, cook_pos)
								cooknum=cooknum+1
							elseif ingredient:IsValid() then
								act.doer.components.inventory:GiveItem(ingredient, nil, cook_pos)
							end
						end
					end
					return cooknum>0
				end
				return old_cook_fn(act)
			end,
		},
	},
	--攻击(修改弹弓射击动作)
	{
		switch = true,
		id = "ATTACK",
		state = {
			testfn=function(inst, action)
				if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or (inst.components.health and inst.components.health:IsDead())) then
					local weapon = inst.components.combat ~= nil and inst.components.combat:GetWeapon() or nil
					return inst:HasTag("senior_childishness") and weapon and weapon:HasTag("slingshot")
				end
			end,
			--客机动作劫持
			client_testfn=function(inst, action)
				if not (inst.sg:HasStateTag("attack") and action.target == inst.sg.statemem.attacktarget or (inst.replica.health and inst.replica.health:IsDead()))  then
					local weapon = inst.replica.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
					return inst:HasTag("senior_childishness") and weapon and weapon:HasTag("slingshot")
				end
			end,
			deststate=function(inst,action)
				inst.sg.mem.localchainattack = not action.forced or nil
				return "medal_slingshot_shoot"
			end,
		},
	},
	--钓鱼
	{
		switch = true,
		id = "FISH",
		actiondata = {
			fn = function(act)
				if act.target.prefab=="lava_pond" and act.invobject.prefab~="medal_fishingrod" then
					return false
				end
				if old_fish_fn then
					return old_fish_fn(act)
				end
			end,
		},
		state = {
			testfn=function(inst, action)
				return action.target.prefab=="lava_pond"
			end,
			deststate=function(inst,action)
				-- return "fishing_pre"
				if not inst:HasTag("medal_fishingrod") then
					-- print("不能钓")
					if inst.components.talker and not inst:HasTag("mime") then
						inst.components.talker:Say(STRINGS.FISHINGMEDALSPEECH.CANTFISH)
					end
				end
				return inst:HasTag("medal_fishingrod") and "fishing_pre" or "idle"
			end,
		},
	},
}

return {
	actions = actions,
	component_actions = component_actions,
	old_actions = old_actions,
}