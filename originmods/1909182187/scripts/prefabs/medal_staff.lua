local easing = require("easing")

----------------------------------------公用函数------------------------------------------
--耐久用完移除施法组件
local function staff_onfinished(inst)
    if inst.components.spellcaster~=nil then
		inst:RemoveComponent("spellcaster")
	end
end
--播放特效
local function spawnFX(fx,target,x,y,z)
	if TUNING.SHOW_MEDAL_FX then
		if target then
			SpawnPrefab(fx).Transform:SetPosition(target.Transform:GetWorldPosition())
		else
			SpawnPrefab(fx).Transform:SetPosition(x,y,z)
		end
	end
end

----------------------------------------吞噬法杖------------------------------------------
--诱饵
local baits_list={
	"powcake",--火药饼
	"winter_food4",--水果蛋糕
	"mandrake",--曼德拉草
}
--判断诱饵是否围在墙内
local function isInsideWall(item)
	if not table.contains(baits_list,item.prefab) then
		return false
	end
	local x,y,z = item.Transform:GetWorldPosition()
	local ents = TheSim:FindEntities(x,y,z,2,{"wall"},{"INLIMBO"})
	local wallNum = 0
	for i, v in ipairs(ents) do
		if v.components.health then
			wallNum = wallNum + 1 
		end 
	end
	return wallNum>=5
end
--是否是蜂箱边上的花
local function isHoneyFlower(item)
	if item:HasTag("flower") then
		local x,y,z = item.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z,6,{"beebox"},{"INLIMBO"})
		if ents and #ents>0 then
			return true
		end
	end
	return false
end
--计算饱食消耗(玩家,物品,计数)
local function getHungerLoss(player,item,count)
	local distance=math.sqrt(player:GetDistanceSqToInst(item))--吞噬距离
	return (distance/4)*count*TUNING_MEDAL.DEVOUR_STAFF_SANITY_MULT--吞噬消耗
end

--拾取物品(物品，玩家，是否针对单个目标)
local function pickitem(item,player,single)
	local hungerLoss=0--饱食消耗
	if not single then
		--如果是曼德拉草，不捡
		if item.prefab=="mandrake_planted" then
			return hungerLoss
		end
		--如果是围在墙内的诱饵就不捡
		if isInsideWall(item) then
			return hungerLoss
		end
		--如果是部署好的陷阱则不捡
		if item:HasTag("trap") and item.components.inventoryitem and item.components.inventoryitem.nobounce then
			return hungerLoss
		end
		--如果是布置类的陷阱，在布置好的情况下不捡
		if item.components.trap and item.components.trap.isset then
			return hungerLoss
		end
	end
	if player~=nil and player.components.inventory~=nil then
		---------------挖取木桩----------------
		if player.large_chop and item:HasTag("stump") then
			--树桩产物表
			local treelist={
				livingtree_halloween="livinglog",--万圣节活木树
				livingtree="livinglog",--活木树
				driftwood_tall="driftwood_log",--浮木树
				medal_fruit_tree_stump="medaldug_fruit_tree_stump",--砧木桩
			}
			local logitem="log"
			--根据不同树桩给不同木头，桦木树比较特殊需要特殊判断
			if item.prefab=="deciduoustree" and item.monster then
				logitem="livinglog"
			elseif treelist[item.prefab] then
				logitem=treelist[item.prefab]
			end
			hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
			spawnFX("spawn_fx_tiny",item)
			player.components.inventory:GiveItem(SpawnPrefab(logitem))
			item:Remove()
			--植物人额外多消耗2点精神值
			-- if player.prefab=="wormwood" then
			-- 	hungerLoss = hungerLoss+2
			-- end
			return hungerLoss
		end
		-----------------------丰收勋章采集、收获资源-------------------------
		if player.quickpickmedal then
			--采集
			if item:HasTag("pickable") and item.components.pickable then
				--范围采集的时候不采集蜂箱边上的花
				if isHoneyFlower(item) and not single then
					return hungerLoss
				end
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_tiny",item)
				if item.prefab=="tumbleweed" and player.components.lucky~=nil then
					player.components.lucky:DoDelta(-(TUNING.GAME_LEVEL or 1))--额外扣除幸运值
				end
				item.components.pickable:Pick(player)
				return hungerLoss
			end
			--蘑菇农场、蜂箱等
			if item.components.harvestable then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small",item)
				item.components.harvestable:Harvest(player)
				return hungerLoss
			end
			--农作物
			if item.components.crop then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_tiny",item)
				item.components.crop:Harvest(player)
				return hungerLoss
			end
			--锅
			if item.components.stewer then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small_high",item)
				item.components.stewer:Harvest(player)
				return hungerLoss
			end
			--晒肉架
			if item.components.dryer then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small_high",item)
				item.components.dryer:Harvest(player)
				return hungerLoss
			end
			--眼球草
			if item.components.shelf then
				hungerLoss=getHungerLoss(player,item,TUNING_MEDAL.DEVOUR_STAFF_HARVEST_COUNT)
				spawnFX("spawn_fx_small_high",item)
				item.components.shelf:TakeItem(player)
				return hungerLoss
			end
		end
		---------------拾取道具-------------------
		if item.components.inventoryitem and item.components.inventoryitem.canbepickedup and item.components.inventoryitem.cangoincontainer and not item.components.inventoryitem:IsHeld() then
			local stacknum = item.components.stackable and item.components.stackable:StackSize() or 1--堆叠数量
			--如果是触发后的陷阱则拾取
			if item.components.trap and item.components.trap:IsSprung() then
				hungerLoss=getHungerLoss(player,item,1)
				spawnFX("spawn_fx_tiny",item)
				item.components.trap:Harvest(player)
				return hungerLoss
			end
			--有新鲜度则优先消耗新鲜度
			--[[ if item.components.perishable ~= nil and item.components.perishable:GetPercent() > .4 then
				--如果食物的新鲜度超过最低新鲜值就随机降低0-0.2，不低于最低值，否则消耗饱食度
				item.components.perishable:SetPercent(item.components.perishable:GetPercent() - math.min(math.random()*0.2,item.components.perishable:GetPercent()-0.4))
			end ]]
			--消耗计算
			hungerLoss=getHungerLoss(player,item,math.ceil(stacknum/5))--堆叠的减少消耗,每5个按1个算
			spawnFX("spawn_fx_tiny",item)
			player.components.inventory:GiveItem(item,nil,item:GetPosition())
			return hungerLoss
		end
	end
	return hungerLoss
end

--施法拾取物品函数
local function pickup_func(inst,target,pos)
	local caster = inst.components.inventoryitem.owner--施法者
	local hungerLoss=0--饱食度消耗
	local findList={"_inventoryitem"}--需检索的标签列表
	local bigradius=false--大范围施法
	if caster then
		--丰收勋章
		if caster.quickpickmedal then 
			findList={"_inventoryitem","pickable","harvestable","readyforharvest","donecooking","dried","takeshelfitem"}
			bigradius=true
		end
		--高级伐木勋章
		if caster.large_chop then 
			-- findList={"_inventoryitem","stump"}
			table.insert(findList,"stump")
			bigradius=true
		end
	end
	
	local castRadius=bigradius and TUNING_MEDAL.IMMORTAL_STAFF_RADIUS or TUNING_MEDAL.DEVOUR_STAFF_RADIUS--施法范围
	local scalefx=bigradius and "immortal_staff_scale_fx" or "devour_staff_scale_fx"--范围圈特效
	--对点使用
	if pos then
		local x,y,z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , {"INLIMBO", "NOCLICK", "catchable", "fire","notdevourable"},findList)
		spawnFX(scalefx,nil,x,y,z)
		if #ents>0 then
			for i,v in ipairs(ents) do
				hungerLoss=hungerLoss+pickitem(v,caster,false)
			end
		end
	--对单个目标使用
	elseif target then
		if caster ~= nil and caster.components.inventory~=nil then
			hungerLoss=hungerLoss+pickitem(target,caster,true)
		end
	--在装备栏使用
	elseif caster then
		local x,y,z = caster.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, castRadius ,nil , {"INLIMBO", "NOCLICK", "catchable", "fire","notdevourable"},findList)
		spawnFX(scalefx,nil,x,y,z)
		if #ents>0 then
			for i,v in ipairs(ents) do
				hungerLoss=hungerLoss+pickitem(v,caster,false)
			end
		end
	end
	
	if hungerLoss>0 then
		local hungerLoss=math.min(math.ceil(hungerLoss),TUNING_MEDAL.DEVOUR_STAFF_SANITY_MAX)
		-- print("本次消耗"..hungerLoss)
		--扣除法杖耐久
		if inst.components.finiteuses then
			local use=inst.components.finiteuses:GetUses()
			inst.components.finiteuses:Use(hungerLoss)
			hungerLoss=hungerLoss-use
		end
		--扣除玩家饱食度
		if hungerLoss>0 and caster and caster.components.hunger then
			caster.components.hunger:DoDelta(-hungerLoss)
		end
	end
end

--判断是否为有效施法目标
local function devour_can_cast_fn(doer, target, pos)
	--可库存的
	if target.components.inventoryitem ~= nil then
		return true
	end
	local taglist={
		"pickable",--可采集的
		"harvestable",--可收获的
		"readyforharvest",--可收获的(农作物)
		"donecooking",--烹饪好的料理
		"dried",--晒好的东西
		"takeshelfitem",--架子(眼球草)
	}
	--如果玩家戴了丰收勋章
	if doer.quickpickmedal then
		for k,v in ipairs(taglist) do
			if target:HasTag(v) then
				return true
			end
		end
	end
	--如果玩家有高级伐木勋章标签
	if doer.large_chop then
		--树桩
		if target:HasTag("stump") then
			return true
		end
	end
	
    return false
end

----------------------------------------不朽法杖------------------------------------------
--各阶段石化树数据
local STAGE_PETRIFY_DATA =
{
	normal={
		{--小树
			consume=2,--耐久消耗
			prefab="rock_petrified_tree_short",--对应的石化树
			fx="petrified_tree_fx_short",--对应的石化特效
		},
		{--中树
			consume=3,
			prefab="rock_petrified_tree_med",
			fx="petrified_tree_fx_normal",
		},
		{--大树
			consume=4,
			prefab="rock_petrified_tree_tall",
			fx="petrified_tree_fx_tall",
		},
		{--枯树
			consume=2,
			prefab="rock_petrified_tree_old",
			fx="petrified_tree_fx_old",
		},
	},
	--大理石树
	marble={
		{--小树
			consume=3,--耐久消耗
			prefab="marbleshrub_short",--对应的石化树
			fx="petrified_tree_fx_short",--对应的石化特效
		},
		{--中树
			consume=3,
			prefab="marbleshrub_normal",
			fx="petrified_tree_fx_normal",
		},
		{--大树
			consume=3,
			prefab="marbleshrub_tall",
			fx="petrified_tree_fx_tall",
		},
	},
	--硝化树
	nitrify={
		{--小树
			consume=3,--耐久消耗
			prefab="medal_nitrify_tree_short",--对应的石化树
			fx="petrified_tree_fx_short",--对应的石化特效
		},
		{--中树
			consume=4,
			prefab="medal_nitrify_tree_med",
			fx="petrified_tree_fx_normal",
		},
		{--大树
			consume=5,
			prefab="medal_nitrify_tree_tall",
			fx="petrified_tree_fx_tall",
		},
		{--枯树
			consume=3,
			prefab="medal_nitrify_tree_old",
			fx="petrified_tree_fx_old",
		},
	},
}

--转移容器内物品(原容器,新容器)
local function transferEverything(inst,obj)
	if inst.components.container and not inst.components.container:IsEmpty() then
		if obj.components.container then
			local allitems=inst.components.container:RemoveAllItemsWithSlot()
			if allitems then
				for k,v in pairs(allitems) do
					obj.components.container:GiveItem(v,k)
				end
			end
		end
	end
end

local immortal_fn_loot={
	{--打蜡
		testfn=function(target) return target:HasTag("waxable") end,
		spellfn=function(staff,target)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=10 then
				local waxedveggie = SpawnPrefab(target.prefab.."_waxed")
				if waxedveggie then
					waxedveggie.Transform:SetPosition(target.Transform:GetWorldPosition())
					waxedveggie.AnimState:PlayAnimation("wax_oversized", false)
					waxedveggie.AnimState:PushAnimation("idle_oversized")
					target:Remove()
					staff.components.finiteuses:Use(10)
				end
				return true
			end
			return false
		end,
	},
	--[[
	{--生成坎普斯宝匣
		testfn=function(target) return target.prefab=="krampus_sack" and target:HasTag("keepfresh") end,
		spellfn=function(staff,target)
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=100 then
				local newbox = SpawnPrefab("medal_krampus_chest_item")
				if newbox then
					newbox.Transform:SetPosition(target.Transform:GetWorldPosition())
					spawnFX("halloween_firepuff_1",target)
					transferEverything(target,newbox)
					target:Remove()
					staff.components.finiteuses:Use(100)
				end
				return true
			end
			return false
		end,
	},
	]]
	{--石化
		testfn=function(target) return (target:HasTag("petrifiable") or target:HasTag("deciduoustree")) and target.components.growable ~= nil and not target:HasTag("stump") end,
		spellfn=function(staff,target)
			local stage = target.components.growable.stage or 1--树的级别
			local petrify_loot = target:HasTag("deciduoustree") and STAGE_PETRIFY_DATA.marble or STAGE_PETRIFY_DATA.normal--石化树信息表
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=petrify_loot[stage].consume then
				local rock = SpawnPrefab(petrify_loot[stage].prefab)
				if rock then
					local r, g, b = target.AnimState:GetMultColour()
					rock.AnimState:SetMultColour(r, g, b, 1)
					rock.Transform:SetPosition(target.Transform:GetWorldPosition())
					local fx = SpawnPrefab(petrify_loot[stage].fx)
					fx.Transform:SetPosition(target.Transform:GetWorldPosition())
					fx:InheritColour(r, g, b)
					target:Remove()
					staff.components.finiteuses:Use(petrify_loot[stage].consume)
				end
				return true
			end
			return false
		end,
	},
	{--硝化
		testfn=function(target) return target.prefab=="rock_petrified_tree" end,
		spellfn=function(staff,target)
			local stage = target.treeSize or 1--树的级别
			local petrify_loot = STAGE_PETRIFY_DATA.nitrify--石化树信息表
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=petrify_loot[stage].consume then
				local rock = SpawnPrefab(petrify_loot[stage].prefab)
				if rock then
					-- local r, g, b = target.AnimState:GetMultColour()
					-- rock.AnimState:SetMultColour(r, g, b, 1)
					rock.Transform:SetPosition(target.Transform:GetWorldPosition())
					local fx = SpawnPrefab(petrify_loot[stage].fx)
					fx.Transform:SetPosition(target.Transform:GetWorldPosition())
					-- fx:InheritColour(r, g, b)
					target:Remove()
					staff.components.finiteuses:Use(petrify_loot[stage].consume)
				end
				return true
			end
			return false
		end,
	},
	{--腐烂作物回春术
		testfn=function(target) return target:HasTag("pickable_harvest_str") or target:HasTag("weed") end,
		spellfn=function(staff,target)
			local consume=(target.is_oversized or not target:HasTag("farm_plant")) and 10 or 4
			if staff.components.finiteuses and staff.components.finiteuses:GetUses()>=consume then
				if target.components.growable then
					--巨型腐烂作物(长地里的)
					if target.is_oversized then
						local bigPlant=SpawnPrefab(target.prefab)
						if bigPlant then
							bigPlant.Transform:SetPosition(target.Transform:GetWorldPosition())
							bigPlant.force_oversized=true
							for i = 1, 4 do
								bigPlant.components.growable:DoGrowth()
							end
							target:Remove()
							staff.components.finiteuses:Use(consume)
						end
						return true
					--杂草
					elseif target:HasTag("weed") then
						if target.components.growable:GetStage()==4 then
							local newweed=SpawnPrefab(target.prefab)
							if newweed then
								newweed.Transform:SetPosition(target.Transform:GetWorldPosition())
								if newweed.components.growable and newweed.components.growable.domagicgrowthfn then
									newweed.components.growable:DoMagicGrowth()
								end
								target:Remove()
								staff.components.finiteuses:Use(consume)
							end
						end
						return true
					else--普通作物
						if target.components.growable.domagicgrowthfn ~= nil then
							target.components.growable:DoMagicGrowth()
						else
							target.components.growable:DoGrowth()
						end
						staff.components.finiteuses:Use(consume)
						return true
					end
				--巨型腐烂作物(已经采摘过的)
				elseif string.sub(target.prefab,-16,-1)=="oversized_rotten" then
					local bigPlant=SpawnPrefab(string.sub(target.prefab,1,-8))
					if bigPlant then
						bigPlant.Transform:SetPosition(target.Transform:GetWorldPosition())
						spawnFX("halloween_firepuff_1",target)
						target:Remove()
						staff.components.finiteuses:Use(consume)
					end
					return true
				end
			end
			return false
		end,
	},
}

--不朽法杖作用目标所需标签
local IMMORTAL_NEED_TAG_LIST={
	"petrifiable",--可石化
	"deciduoustree",--桦树
	"waxable",--可打蜡
	-- "keepfresh",--不朽背包
	"nitrifyable",--可硝化
	"pickable_harvest_str",--腐烂农作物
	"weed",--杂草
}
--施法函数
local function immortal_func(inst,target,pos)
	local caster = inst.components.inventoryitem.owner--施法者
	--对点使用
	if pos then
		local x,y,z = pos:Get()
		local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, {"INLIMBO", "NOCLICK"},IMMORTAL_NEED_TAG_LIST)
		spawnFX("immortal_staff_scale_fx",nil,x,y,z)
		if #ents>0 then
			local need_sigh=true--是否发出感叹词
			for i,v in ipairs(ents) do
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.spellfn and imfn.spellfn(inst,v) then
							need_sigh=false
							break
						end
					end
				end
			end
			if need_sigh then--发出不朽之力不够了的感叹词
				if caster and caster.components.talker and not caster:HasTag("mime") then
					caster.components.talker:Say(STRINGS.IMMORTALSPEECH.POWERNOTENOUGH)
				end
			end
		end
	--对单个目标使用
	elseif target then
		local need_sigh=true--是否发出感叹词
		for _,imfn in ipairs(immortal_fn_loot) do
			if imfn.testfn==nil or imfn.testfn(target) then
				if imfn.spellfn and imfn.spellfn(inst,target) then
					need_sigh=false
					break
				end
			end
		end
		if need_sigh then--发出不朽之力不够了的感叹词
			if caster and caster.components.talker and not caster:HasTag("mime") then
				caster.components.talker:Say(STRINGS.IMMORTALSPEECH.POWERNOTENOUGH)
			end
		end
		
	--在装备栏使用
	elseif caster then
		local x,y,z = caster.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.IMMORTAL_STAFF_RADIUS ,nil, {"INLIMBO", "NOCLICK"},IMMORTAL_NEED_TAG_LIST)
		spawnFX("immortal_staff_scale_fx",nil,x,y,z)
		if #ents>0 then
			local need_sigh=true--是否发出感叹词
			for i,v in ipairs(ents) do
				for _,imfn in ipairs(immortal_fn_loot) do
					if imfn.testfn==nil or imfn.testfn(v) then
						if imfn.spellfn and imfn.spellfn(inst,v) then
							need_sigh=false
							break
						end
					end
				end
			end
			if need_sigh then--发出不朽之力不够了的感叹词
				if caster and caster.components.talker and not caster:HasTag("mime") then
					caster.components.talker:Say(STRINGS.IMMORTALSPEECH.POWERNOTENOUGH)
				end
			end
		end
	end
end

--判断是否为有效施法目标
local function immortal_can_cast_fn(doer, target, pos)
	for k,v in ipairs(IMMORTAL_NEED_TAG_LIST) do
		if target:HasTag(v) then
			return true
		end
	end
    return false
end

----------------------------------------流星法杖------------------------------------------
--流星攻击
local function meteor_onattack(inst, attacker, target, skipsanity)
	if not target:IsValid() or not inst.components.spellcaster then
        return
    end
	SpawnPrefab("shadowmeteor").Transform:SetPosition(target.Transform:GetWorldPosition())
end

--召唤单颗流星
local function call_a_meteor(px,py,pz)
	local theta = math.random() * 2 * PI
	local radius = easing.outSine(math.random(), math.random() * TUNING_MEDAL.METEOR_STAFF_RADIUS, TUNING_MEDAL.METEOR_STAFF_RADIUS, 1)
	local fan_offset = FindValidPositionByFan(theta, radius, 30,
		function(offset)
			return TheWorld.Map:IsPassableAtPoint(px + offset.x, py + offset.y, pz + offset.z)
		end)
	local met = SpawnPrefab("shadowmeteor")
	met.Transform:SetPosition(px + fan_offset.x, py + fan_offset.y, pz + fan_offset.z)
end

--召唤流星雨
local function call_meteor_func(inst,target,pos)
	local caster = inst.components.inventoryitem.owner--施法者
	local num_meteor = math.random(15,30)--流星数量
	--对点使用
	if pos then
		SpawnPrefab("shadowmeteor").Transform:SetPosition(pos:Get())
		inst.components.finiteuses:Use(1)
	--对单个目标使用
	elseif target then
		SpawnPrefab("shadowmeteor").Transform:SetPosition(target.Transform:GetWorldPosition())
		inst.components.finiteuses:Use(1)
	--在装备栏使用
	elseif caster then
		local px,py,pz= caster.Transform:GetWorldPosition()
		caster:StartThread(function()
			for k = 0, num_meteor-1 do
				call_a_meteor(px,py,pz)
				Sleep(.3 + math.random() * .2)
			end
		end)
		inst.components.finiteuses:Use(math.min(inst.components.finiteuses:GetUses(),20))
	end
end

----------------------------------------法杖列表------------------------------------------
local staff_defs={
	--吞噬法杖
	devour_staff={
		name="devour_staff",
		animname="devour_staff",
		taglist={"medalquickcast","allow_action_on_impassable"},--单目标快速施法、不可通行区域施法
		maxuse=TUNING_MEDAL.DEVOUR_STAFF_USES,--最大耐久
		onfinishedfn=staff_onfinished,--耐久用完函数
		fxcolour={73/255,120/255,81/255},--施法颜色
		radius=TUNING_MEDAL.DEVOUR_STAFF_RADIUS,--作用范围
		spellfn=function(inst)--施法函数
			inst:AddComponent("spellcaster")
			inst.components.spellcaster:SetSpellFn(pickup_func)--捡东西
			inst.components.spellcaster.canuseontargets = true--对某一个目标使用
			inst.components.spellcaster.canuseonpoint = true--对坐标点使用
			inst.components.spellcaster.canuseonpoint_water = true--船上使用
			inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
			inst.components.spellcaster:SetCanCastFn(devour_can_cast_fn)--有效目标函数
		end,
	},
	--不朽法杖
	immortal_staff={
		name="immortal_staff",
		animname="immortal_staff",
		taglist={"medalquickcast","adduseable_staff","allow_action_on_impassable"},--单目标快速施法、可补充耐久、不可通行区域施法
		adduseitem={"immortal_essence"},--可补充耐久的物品列表
		adduse=TUNING_MEDAL.IMMORTAL_ESSENCE_ADDUSE,--单次补充耐久
		maxuse=TUNING_MEDAL.IMMORTAL_STAFF_USES,--最大耐久
		onfinishedfn=staff_onfinished,--耐久用完函数
		fxcolour={200/255,132/255,133/255},--施法颜色
		radius=TUNING_MEDAL.IMMORTAL_STAFF_RADIUS,--作用范围
		spellfn=function(inst)--施法函数
			inst:AddComponent("spellcaster")
			inst.components.spellcaster:SetSpellFn(immortal_func)--石化
			inst.components.spellcaster.canuseontargets = true--对某一个目标使用
			inst.components.spellcaster.canuseonpoint = true--对坐标点使用
			inst.components.spellcaster.canuseonpoint_water = true--船上使用
			inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
			inst.components.spellcaster:SetCanCastFn(immortal_can_cast_fn)--有效目标函数
		end,
	},
	--流星法杖
	meteor_staff={
		name="meteor_staff",
		animname="meteor_staff",
		taglist={"adduseable_staff","meteor_protection","medalposquickcast"},--可补充耐久、不会被流星砸坏、对目标点快速施法
		adduseitem={"moonrocknugget"},--可补充耐久的物品列表,月石
		adduse=TUNING_MEDAL.METEOR_MEDAL_ADDUSE,--单次补充耐久
		maxuse=TUNING_MEDAL.METEOR_STAFF_USES,--最大耐久
		onfinishedfn=staff_onfinished,--耐久用完函数
		fxcolour={200/255,132/255,133/255},--施法颜色
		spellfn=function(inst)--施法函数
			inst:AddComponent("spellcaster")
			inst.components.spellcaster:SetSpellFn(call_meteor_func)--召唤流星雨
			inst.components.spellcaster.canuseonpoint = true--对坐标点使用
			inst.components.spellcaster.canusefrominventory = true--在装备栏右键使用
		end,
		extrafn=function(inst)--扩展函数
			inst.components.weapon:SetDamage(0)
			inst.components.weapon:SetRange(15, 16)
			inst.components.weapon:SetOnAttack(meteor_onattack)
			-- inst.components.weapon:SetProjectile("fire_projectile")
		end,
	},
	--换肤法杖
	-- medal_skin_staff={
	-- 	name="medal_skin_staff",
	-- 	animname="immortal_staff",
	-- 	taglist={"medalquickcast"},--单目标快速施法
	-- 	maxuse=TUNING_MEDAL.MEDAL_SKIN_STAFF_USES,--最大耐久
	-- 	onfinishedfn=staff_onfinished,--耐久用完函数
	-- 	fxcolour={73/255,120/255,81/255},--施法颜色
	-- 	spellfn=function(inst)--施法函数
	-- 		inst:AddComponent("spellcaster")
	-- 		inst.components.spellcaster:SetSpellFn(function(inst,target,pos)
	-- 			if target and target.change_medal_skin then
	-- 				target:change_medal_skin(true)
	-- 			end
	-- 		end)--换皮肤
	-- 		inst.components.spellcaster.canuseontargets = true--对某一个目标使用
	-- 		inst.components.spellcaster:SetCanCastFn(function(doer, target, pos)
	-- 			if target:HasTag("medalskinable") then
	-- 				return true
	-- 			end
	-- 			return false
	-- 		end)--有效目标函数
	-- 	end,
	-- },
}


--定义法杖
local function MakeStaff(def)
	local assets ={
		Asset("ANIM", "anim/"..def.animname..".zip"),
		Asset("ANIM", "anim/floating_items.zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}
	
	--装备
	local function onequip(inst, owner)
		owner.AnimState:OverrideSymbol("swap_object", def.animname, "swap_"..def.animname)
		owner.AnimState:Show("ARM_carry")
		owner.AnimState:Hide("ARM_normal")
	end
	--卸下
	local function onunequip(inst, owner)
		owner.AnimState:Hide("ARM_carry")
		owner.AnimState:Show("ARM_normal")
	end
	--初始化
	local function fn()
		local inst = CreateEntity()

		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(def.animname)
		inst.AnimState:SetBuild(def.animname)
		inst.AnimState:PlayAnimation(def.animname)

		inst:AddTag("weapon")
		
		if def.taglist and #def.taglist>0 then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end
		if def.adduseitem and #def.adduseitem>0 then
			for _,v in ipairs(def.adduseitem) do
				inst:AddTag("adduse_"..v)
			end
		end

		local floater_swap_data =
		{
			sym_build = def.animname,
			sym_name = "swap_"..def.animname,
			bank = def.animname,
			anim = def.animname
		}
		MakeInventoryFloatable(inst, "med", 0.1, {0.9, 0.4, 0.9}, true, -13, floater_swap_data)
		
		inst.medal_show_radius = def.radius
		
		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("weapon")
		inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name
		inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"

		inst:AddComponent("equippable")
		inst.components.equippable:SetOnEquip(onequip)
		inst.components.equippable:SetOnUnequip(onunequip)
		
		inst.fxcolour = def.fxcolour or {73/255,120/255,81/255}
		--施法函数
		if def.spellfn then
			def.spellfn(inst)
			inst.OnSpellCasterFn=def.spellfn--挂载施法函数，方便后续调用
		end
		--耐久组件
		if def.maxuse then
			inst:AddComponent("finiteuses")
			inst.components.finiteuses:SetOnFinished(def.onfinishedfn or inst.Remove)
			inst.components.finiteuses:SetMaxUses(def.maxuse)
			inst.components.finiteuses:SetUses(def.maxuse)
			inst.adduse=def.adduse
			inst.maxuse=def.maxuse
			inst:ListenForEvent("percentusedchange", function(inst,data)
				if data and data.percent then
					--耐久用完后补充耐久
					if data.percent>0 and inst.components.spellcaster==nil then
						def.spellfn(inst)
					end
				end
			end)
		end
		--扩展函数
		if def.extrafn then
			def.extrafn(inst)
		end

		MakeHauntableLaunch(inst)

		return inst
	end

	return Prefab(def.name, fn, assets)
end

local medal_staffs={}
for i, v in pairs(staff_defs) do
	print(v.name)
    table.insert(medal_staffs, MakeStaff(v))
end
return unpack(medal_staffs)
