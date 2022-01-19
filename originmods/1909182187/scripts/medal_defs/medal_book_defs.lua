local easing = require("easing")

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

--设置随机皮肤
local function setRandomSkinMedal(item,player)
	--生成皮肤
	local skin_list={}--皮肤列表
	if item:IsValid() and PREFAB_SKINS[item.prefab] ~= nil then
		if player~=nil and player:HasTag("player") then
			for _,item_type in pairs(PREFAB_SKINS[item.prefab]) do
				--如果玩家能使用皮肤，插入皮肤列表
				if TheInventory:CheckClientOwnership(player.userid, item_type) then
					table.insert(skin_list,item_type)
				end
			end
			if #skin_list>0 then
				--更改目标皮肤（目标全局标识符，原皮肤名，新皮肤名，xxx，玩家ID）
				TheSim:ReskinEntity(item.GUID, item.skinname, skin_list[math.random(#skin_list)], nil, player.userid )
			end
		end
	end
end

----------------生成各种怪圈(玩家,预置物列表,感叹词)-----------------
local function spawnCircleItem(player,spawnLoot,talk)
	if player then
		local px,py,pz = player.Transform:GetWorldPosition()--获取玩家坐标
		local item=nil--空实体
		--遍历生成物列表
		for _,v in ipairs(spawnLoot) do
			--对玩家执行函数
			if v.playerfn then
				v.playerfn(player)
			end
			--有代码则生成对应预置物
			if v.item or v.randomlist then
				local num=v.num or 1--生成数量
				local specialnum=v.specialfn and math.random(num)-1 or nil--特殊道具
				--生成怪圈
				for i=0,num-1 do
					local code=v.item--预置物代码
					if v.randomlist then
						code=GetRandomItem(v.randomlist)--从随机列表里取一种
					end
					local angle_offset=v.angle_offset or 0--角度偏移
					local angle = (i+angle_offset) * 2 * PI / (num)--根据数量计算角度
					local tries =v.offset and 5 or 1--尝试生成次数,有偏移值的情况下要多次尝试生成,避免少刷
					local canspawn=nil--是否可生成
					for j=1,tries do
						--有偏移值则用偏移值生成坐标，否则根据半径生成坐标，没半径则原地生成
						local ix=v.offset and (math.random()*2-1)*v.offset+px or v.radius and v.radius*math.cos(angle)+px or px
						local iy=0--py--别在天上生成了
						local iz=v.offset and (math.random()*2-1)*v.offset+pz or v.radius and v.radius*math.sin(angle)+pz or pz
						--水中奇遇则判断坐标点是不是在水里
						if v.iswater then
							canspawn = TheWorld.Map:IsOceanAtPoint(ix, iy, iz)
						else
							canspawn = TheWorld.Map:IsPassableAtPoint(ix, iy, iz)
						end
						--坐标点可生成则生成，否则继续尝试
						if canspawn then
							item = SpawnPrefab(code)
							if item then
								item.Transform:SetPosition(ix, iy, iz)
								--如果没有特意取消，那么开出来的生物默认仇恨玩家
								if item.components.combat and not v.noaggro then
									item.components.combat:SuggestTarget(player)
								end
								--有特殊函数则执行特殊函数
								if specialnum and i==specialnum then
									v.specialfn(item,player)
								elseif v.itemfn then--否则执行正常预置物函数
									v.itemfn(item,player)
								end
							end
							break
						end
					end
				end
			end
		end
		--发出感叹词
		if talk and player.components.talker and not player:HasTag("mime") then
			player.components.talker:Say(talk)
		end
	end
end

------------------------献祭加成函数(书本,玩家,献祭品表,召唤物表)-----------------------------
local function doSacrifice(inst,player,itemlist,summonedlist)
	local chance_list=deepcopy(summonedlist)--权重统计表
	local weight_add_list={}--权重加成表
	--获取玩家坐标并对周围献祭品进行统计
	local x, y, z = player.Transform:GetWorldPosition()
	local ents=TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,nil, { "INLIMBO","player" })
	--显示范围圈
	if #ents>0 then
		for i,v in ipairs(ents) do
			--如果献祭品列表里有对应献祭品，则对权重进行增值
			if itemlist[v.prefab] then
				--部分物品不能在洞穴里献祭
				if not (itemlist[v.prefab].nocave and TheWorld and TheWorld:HasTag("cave")) then
					--需要有特定标签才能献祭
					if not itemlist[v.prefab].notag or not v:HasTag(itemlist[v.prefab].notag) then
						local itemnum= v.components.stackable and v.components.stackable:StackSize() or 1--献祭品数量
						local consumenum=itemnum--祭品需消耗数量
						--权重增值登记
						if weight_add_list[itemlist[v.prefab].key] then
							if itemlist[v.prefab].maxnum then
								consumenum=math.min(itemnum,itemlist[v.prefab].maxnum-weight_add_list[itemlist[v.prefab].key].num)
							end
							if consumenum>0 then
								weight_add_list[itemlist[v.prefab].key].num=weight_add_list[itemlist[v.prefab].key].num+consumenum
								weight_add_list[itemlist[v.prefab].key].weight=weight_add_list[itemlist[v.prefab].key].weight+itemlist[v.prefab].chance*consumenum
							end
						else
							if itemlist[v.prefab].maxnum then
								consumenum=math.min(itemnum,itemlist[v.prefab].maxnum)
							end
							weight_add_list[itemlist[v.prefab].key]={
								num=consumenum,
								weight=itemlist[v.prefab].chance*consumenum
							}
						end

						if consumenum>0 then
							--播放献祭动画
							if itemlist[v.prefab].fx then
								spawnFX(itemlist[v.prefab].fx,v)
							end
							--移除献祭品
							if v.components.stackable then
								v.components.stackable:Get(consumenum):Remove()
							else
								v:Remove()
							end
						end
					end
				end
			end
		end
	end
	--权重增值
	for k, v in ipairs(chance_list) do
		if weight_add_list[v.key] then
			v.weight=v.weight+weight_add_list[v.key].weight
		end
	end
	return GetMedalRandomItem(chance_list,inst.medal_destiny_num)--返回权重增值后的随机key
end

--高礼帽函数(预置物,是否是特殊的)
local function setTopHatFn(item,isspecial)
	item:AddTag("notdevourable")--不可吞噬
	if item.components.equippable then
		item:RemoveComponent("equippable")
	end
	--设置检查语句
	if item.components.inspectable then
		if isspecial or math.random()<.5 then
			item.components.inspectable:SetDescription(STRINGS.UNSOLVEDSPEECH.HATTRICK_RABBIT)
		else
			item.components.inspectable:SetDescription(STRINGS.UNSOLVEDSPEECH.HATTRICK_MEDAL)
		end
	end
	if item.components.inventoryitem then
		local x,y,z=item.Transform:GetWorldPosition()
		item.components.inventoryitem:SetOnPickupFn(function(inst, pickupguy, src_pos)
			if src_pos then 
				x,y,z=src_pos:Get()
			end
			local ents = TheSim:FindEntities(x, y, z, 6,{"notdevourable"} , { "INLIMBO" })
			inst:Remove()--移除帽子
			SpawnPrefab("explode_reskin").Transform:SetPosition(x,y,z)
			local magic_prop = SpawnPrefab(isspecial and "silence_certificate" or "rabbit")--生成勋章或者兔子
			magic_prop.Transform:SetPosition(x,y,z)
			--掀开一个帽子后移除周围其他的帽子
			if #ents>0 then
				for i,v in ipairs(ents) do
					if v.prefab=="tophat" then
						SpawnPrefab("explode_reskin").Transform:SetPosition(v.Transform:GetWorldPosition())
						v:Remove()
					end
				end
			end
			return true
		end)
	end
end

--雕像列表,chance权重增值,monster怪物名,动画特效
local chesspiece_list={
	land={
		chesspiece_deerclops={chance=12,key="deerclops",fx="collapse_small"},--巨鹿
		chesspiece_bearger={chance=12,key="bearger",fx="collapse_small"},--熊大
		chesspiece_moosegoose={chance=12,key="moose",fx="collapse_small"},--鹿鸭
		chesspiece_dragonfly={chance=12,key="dragonfly",fx="collapse_small"},--蜻蜓
		chesspiece_beequeen={chance=12,key="beequeen",fx="collapse_small"},--蜂后
		chesspiece_toadstool={chance=12,key="toadstool",fx="collapse_small"},--蛤蟆
		chesspiece_minotaur={chance=3,maxchance=30,maxnum=10,key="minotaur",fx="collapse_small"},--犀牛
		bottled_soul={chance=35,key="medal_rage_krampus",fx="messagebottle_break_fx"},--瓶装灵魂--暗夜坎普斯
		fruitflyfruit={chance=35,key="lordfruitfly",notag="fruitflyfruit",fx="collapse_small"},--友好果蝇果--果蝇王
	},
	water={
		chesspiece_malbatross={chance=2,key="malbatross",fx="collapse_small"},--邪天翁
	}
}
--怪物列表(key怪物名,value权重)
local monster_loot={
	land={
		{key="deerclops",weight=2},--巨鹿
		{key="bearger",weight=2},--熊大
		{key="moose",weight=2},--鹿鸭
		{key="dragonfly",weight=2},--蜻蜓
		{key="leif",weight=5},--树精
		{key="spiderqueen",weight=5},--蜘蛛女王
		{key="warg",weight=5},--座狼
		{key="spat",weight=5},--钢羊
		{key="minotaur",weight=1},--远古守卫
		{key="beequeen",weight=1},--蜂后
		{key="toadstool",weight=1},--蛤蟆
		{key="medal_rage_krampus",weight=0},--暗夜坎普斯
		{key="lordfruitfly",weight=0},--果蝇王
	},
	water={
		{key="malbatross",weight=1},--邪天翁
		{key="shark",weight=2},--岩鲨
		{key="grassgator",weight=1},--草鳄鱼
		{key="gnarwail",weight=1},--一角鲸
	}
}

local un_mult = TUNING_MEDAL.UNSOLVED_ITEM_CHANCE_MULT or 1--献祭品权重增值倍数
--未解之谜献祭品列表
local unsolved_item_list={
	land={
		atrium_key={chance=8*un_mult,key="yuangu",fx="spawn_fx_tiny",nocave=true},--远古钥匙--远古祭坛
		spicepack={chance=4*un_mult,key="dachu",fx="spawn_fx_tiny"},--厨师包--大厨套装
		spiderhat={chance=5*un_mult,key="mudi",fx="spawn_fx_tiny"},--蜘蛛帽--蜘蛛墓碑
		lavaeel={chance=4*un_mult,key="ranshao",fx="spawn_fx_tiny"},--熔岩鳗鱼--浴火重生
		tentaclespots={chance=4*un_mult,key="chushou",fx="spawn_fx_tiny"},--触手皮--困兽之斗
		honeycomb={chance=5*un_mult,key="sharenfeng",fx="spawn_fx_tiny"},--蜂巢--杀人蜂窝
		beeswax={chance=5*un_mult,key="sharenfeng",fx="spawn_fx_tiny"},--蜂蜡--杀人蜂窝
		tophat={chance=5*un_mult,key="hattrick",fx="spawn_fx_tiny"},--高礼帽--帽子戏法
		moonrocknugget={chance=2*un_mult,key="liuxingyu",fx="spawn_fx_tiny"},--月石--流星雨
		cave_banana={chance=1*un_mult,maxchance=15,maxnum=15,key="banana_forest",fx="spawn_fx_tiny"},--香蕉--香蕉树
		medal_blue_obsidian={chance=5*un_mult,key="bingshan",fx="spawn_fx_tiny"},--蓝曜石--冰天雪地
	},
	water={
		saltrock={chance=2*un_mult,key="yankuang",fx="spawn_fx_tiny"},--盐晶--盐矿
		kelp={chance=1*un_mult,key="kelprevenge",fx="spawn_fx_tiny"},--海带--复仇海带
	}
}

--未解之谜索引列表
local unsolved_index={
	land={
		{key="yuangu",weight=1},--远古祭坛
		{key="dachu",weight=1},--美味佳肴
		{key="jushi",weight=1},--方尖碑
		{key="jushier",weight=1},--反向方尖碑
		{key="mudi",weight=1},--蜘蛛墓碑
		{key="ranshao",weight=1},--浴火重生
		{key="chushou",weight=1},--困兽之斗
		{key="bingshan",weight=1},--冰天雪地
		{key="turen",weight=1},--愤怒的兔人
		{key="sharenfeng",weight=1},--杀人蜂阵
		{key="hattrick",weight=1},--帽子戏法
		{key="liuxingyu",weight=1},--昆阳之战
		{key="banana_forest",weight=1},--香蕉林
	},
	water={
		{key="yankuang",weight=1},--盐矿雕像
		{key="kelprevenge",weight=1},--不一样的海草
		{key="waterballet",weight=1},--水上芭蕾
		{key="haiguai",weight=1},--海上影怪
		{key="titanic",weight=1},--泰坦尼克号
	}
}

--未解之谜列表
local unsolved_loot={
	yuangu={--远古祭坛
		{item="ancient_altar"},--祭坛
		{item="ruins_statue_mage",num=6,radius=4},--远古雕像
	},
	dachu={--美味佳肴
		--冰箱
		{item="icebox",itemfn=function(inst,player)
			setRandomSkinMedal(inst,player)--设置皮肤
			--放入食材
			local foodlist={
				"ice",--冰
				"berries",--浆果
				"red_cap",--红蘑菇
				"green_cap",--绿蘑菇
				"blue_cap",--蓝蘑菇
				"butterflywings",--蝴蝶翅膀
				"carrot",--胡萝卜
				"pumpkin",--南瓜
				"dragonfruit",--火龙果
				"pomegranate",--石榴
				"corn",--玉米
				"eggplant",--茄子
				"watermelon",--西瓜
				"potato",--土豆
				"kelp",--海带
				"cave_banana",--洞穴香蕉
				"smallmeat",--小肉
				"meat",--大肉
				"drumstick",--鸡腿
				"monstermeat",--怪物肉
				"plantmeat",--食人花肉
				"bird_egg",--鸡蛋
				"fishmeat",--鱼肉
				"froglegs",--蛙腿
				"honey",--蜂蜜
			}
			--随机选5-9种食材(可重复)
			for i=1,math.random(5,9) do
				local food=SpawnPrefab(GetRandomItem(foodlist))
				if food then
					--每种1-3个
					if food.components.stackable then
						food.components.stackable.stacksize = math.random(3)
					end
					if inst.components.container then
						inst.components.container:GiveItem(food)
					else
						food:Remove()
					end
				end
			end
		end},
		--锅
		{item="cookpot",num=3,radius=3,itemfn=function(inst,player)
			setRandomSkinMedal(inst,player)--设置皮肤
		end},
		--远古锅
		{item="medal_cookpot",num=3,radius=3,angle_offset=0.5,itemfn=function(inst,player)
			setRandomSkinMedal(inst,player)--设置皮肤
		end},
	},
	jushi={--方尖碑
		{item="insanityrock",num=6,radius=2},--正向方尖碑
		{playerfn=function(player)--玩家状态函数
			if player.components.sanity~=nil then
				player.components.sanity:SetPercent(0)--精神扣完
			end
		end},
	},
	jushier={--反向方尖碑
		{item="sanityrock",num=6,radius=2},--反向方尖碑
		{playerfn=function(player)--玩家状态函数
			if player.components.sanity~=nil then
				player.components.sanity:SetPercent(1)--精神回满
			end
		end},
	},
	mudi={--蜘蛛墓碑
		{item="gravestone",num=6,radius=4},--墓碑
		--花
		{item="flower",itemfn=function(item,player)
			local spiderLoot={
				"spider_warrior",--蜘蛛战士
				"spider_hider",--洞穴蜘蛛
				"spider_spitter",--喷吐蜘蛛
				"spider_dropper",--悬挂蜘蛛
				"spider_moon",--破碎蜘蛛
				"spiderqueen"--蜘蛛女王
			}
			if item.components.pickable then
				local oldonpickedfn=item.components.pickable.onpickedfn
				--设置采摘函数
				item.components.pickable.onpickedfn = function(inst, picker)
					local pos = inst:GetPosition()
					local canDugMoundCount=0--可挖的坟墓数量
					local spiderMound=nil
					local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 6,{"grave"} , { "INLIMBO" })
					--寻找周围的坟墓
					if #ents>0 then
						for i,v in ipairs(ents) do
							if v.prefab=="mound" then
								if v.components.workable~=nil then
									--如果有没挖过的坟，则计数+1，并生成对应的蜘蛛
									canDugMoundCount=math.min(canDugMoundCount+1,6)
									local spider=SpawnPrefab(spiderLoot[canDugMoundCount])
									v:RemoveComponent("workable")
									v.AnimState:PlayAnimation("dug")
									if spider.components.combat then 
										spider.components.combat:SuggestTarget(picker)
									end
									spider.Transform:SetPosition(v.Transform:GetWorldPosition())
									if picker.components.talker and not picker:HasTag("mime") then
										picker.components.talker:Say(STRINGS.SPIDERMEDALSPEECH.FINDSPIDER) 
									end
								end
							end
						end
					end
					--如果周围没有未挖过的坟堆，则新生成一个蜘蛛坟堆
					if canDugMoundCount==0 then
						spiderMound=SpawnPrefab("mound")
						if spiderMound~= nil then
							spiderMound.Transform:SetPosition(pos.x, pos.y, pos.z)
							if picker.components.talker and not picker:HasTag("mime") then
								picker.components.talker:Say(STRINGS.SPIDERMEDALSPEECH.FINDMOUND) 
							end
							if spiderMound.components.workable then
								spiderMound.components.workable:SetOnFinishCallback(function(inst, worker)
									inst.AnimState:PlayAnimation("dug")
									inst:RemoveComponent("workable")
									if worker ~= nil then
										if worker.components.talker and not worker:HasTag("mime") then
											worker.components.talker:Say(STRINGS.SPIDERMEDALSPEECH.GETMEDAL) 
										end
										if worker.components.sanity ~= nil then
											worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
										end
										inst.components.lootdropper:SpawnLootPrefab("spider_certificate")
									end
								end)
							end
						end
					end
					if oldonpickedfn then
						oldonpickedfn(inst, picker)
					end 
				end
			end
		end},
	},
	ranshao={--浴火重生
		--重生护符
		{item="amulet",itemfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			item:AddTag("powerabsorbable")--可吸收能力
			local function onHauntfn(inst)
				if not inst.medal_used then
					local x, y, z = inst.Transform:GetWorldPosition()
					local newmedal = SpawnPrefab("bathingfire_certificate")
					if newmedal then
						newmedal.Transform:SetPosition(x, y, z)
						inst.medal_used=true--添加标记，防止多次生成浴火
					end
				end
			end
			--设置作祟函数
			AddHauntableCustomReaction(item, onHauntfn, false, true, false)
		end},
		--燃烧的木墙
		{item="wall_wood",num=8,radius=2,itemfn=function(item,player)
			if item.components.burnable then
				item.components.burnable:Ignite(true)
			end
		end},
	},
	chushou={--困兽之斗
		--触手
		{item="tentacle",itemfn=function(item,player)
			if item.components.lootdropper then
				item.components.lootdropper:AddChanceLoot("tentacle_certificate", 1)
			end
		end},
		{playerfn=function(player)--玩家状态函数
			--给玩家一个大理石甲
			if player.components.inventory then
				player.components.inventory:GiveItem(SpawnPrefab("armormarble"))
			end
		end},
		--月墙
		{item="wall_moonrock",num=8,radius=2},
	},
	bingshan={--冰天雪地
		{playerfn=function(player)--玩家状态函数
			--冻住玩家
			if player.components.freezable~=nil then
				player.components.freezable:AddColdness(12,10)--冰冻
			end
		end},
		{item="coldfire",num=10,radius=2,itemfn=function(item,player)
			if item.components.burnable then
				--火灭了出蓝曜石
				item.components.burnable:SetOnExtinguishFn(function(inst)
					if inst.components.lootdropper then
						inst.components.lootdropper:SpawnLootPrefab("medal_blue_obsidian")
					end
				end)
				--2分钟内火不灭就没机会了
				item:DoTaskInTime(120,function()
					item.components.burnable:SetOnExtinguishFn(nil)
				end)
			end
		end,
		specialfn=function(item,player)
			local builder = player and player.components.builder or nil
			--没学过蓝曜石制冰机则给制冰机蓝图
			local specialitem = (builder and not builder:KnowsRecipe("medal_ice_machine")) and "medal_ice_machine_blueprint" or "medal_blue_obsidian"
			if item.components.burnable then
				item.components.burnable:SetOnExtinguishFn(function(inst)
					if inst.components.lootdropper then
						inst.components.lootdropper:SpawnLootPrefab(specialitem)
					end
				end)
				item:DoTaskInTime(120,function()
					item.components.burnable:SetOnExtinguishFn(nil)
				end)
			end
		end},--冷火堆
	},
	turen={--兔人房
		{playerfn=function(player)--玩家状态函数
			--给玩家塞一块肉
			if player.components.inventory then
				player.components.inventory:GiveItem(SpawnPrefab("meat"))
			end
		end},
		{item="rabbithouse",num=6,radius=4},--兔人房
	},
	sharenfeng={--杀人蜂窝
		{item="wasphive",num=6,radius=6,specialfn=function(item,player)
			--只能在地上世界召唤凋零之蜂
			if TheWorld and TheWorld:HasTag("forest") then
				--世界上只能同时存在一个凋零之蜂(包括凋零蜂巢、蔷薇花台、血坑)
				if not TheSim:FindFirstEntityWithTag("medal_beequeen") then
					if item.components.combat then
						local oldonkilledbyother=item.components.combat.onkilledbyother
						item.components.combat.onkilledbyother=function(inst,attacker)
							SpawnPrefab("lucy_transform_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
							SpawnPrefab("medal_rose_terrace").Transform:SetPosition(inst.Transform:GetWorldPosition())
							if oldonkilledbyother then
								oldonkilledbyother(inst,attacker)
							end
						end
					end
				end
			end
		end},--杀人蜂窝
	},
	hattrick={--帽子戏法
		--高礼帽
		{item="tophat",num=3,radius=3,itemfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			setTopHatFn(item,false)--普通高礼帽
		end,
		specialfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			setTopHatFn(item,true)--特殊高礼帽
		end},
	},
	liuxingyu={--流星雨
		{playerfn=function(player)--玩家状态函数
			local num_meteor = 20--流星数量
			if player~=nil then
				local px,py,pz= player.Transform:GetWorldPosition()
				player:StartThread(function()
					local hasstaff=false--是否生成了流星法杖(确保不重复生成)
					for k = 1, num_meteor do
						local theta = math.random() * 2 * PI
						local radius = easing.outSine(math.random(), math.random() * 5, 5, 1)
						local fan_offset = FindValidPositionByFan(theta, radius, 30,
							function(offset)
								return TheWorld.Map:IsPassableAtPoint(px + offset.x, py + offset.y, pz + offset.z)
							end)
						local met = SpawnPrefab("shadowmeteor")
						if not hasstaff then
							met:DoTaskInTime(0.1, function(inst)
								--如果是大流星，则有概率生成流星法杖
								if inst.size and inst.size>1 then
									if math.random()<TUNING_MEDAL.METEOR_STAFF_CHANCE then
										hasstaff=true
										inst.OnRemoveEntity=function(inst)
											local x, y, z = inst.Transform:GetWorldPosition()
											local drop=SpawnPrefab("meteor_staff")
											if drop ~= nil then
												drop.Transform:SetPosition(x, y, z)
												if drop.components.inventoryitem ~= nil then
													drop.components.inventoryitem:OnDropped(true)
												end
											end
										end
									end
								end
							end)
						end
						met.Transform:SetPosition(px + fan_offset.x, py + fan_offset.y, pz + fan_offset.z)
						Sleep(.3 + math.random() * .2)
					end
				end)
			end
		end},
	},
	banana_forest={--香蕉之林
		--香蕉树
		{item="cave_banana_tree",num=6,radius=5,angle_offset=0.5,itemfn=function(item,player)
			item:AddTag("notdevourable")--不可吞噬
			if item.components.pickable then
				local oldonpickedfn = item.components.pickable.onpickedfn
				item.components.pickable.onpickedfn=function(inst,picker)
					if oldonpickedfn then
						oldonpickedfn(inst,picker)
					end
					local x,y,z=inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 12,{"notdevourable"} , { "INLIMBO" })
					local needtalk=false;--是否要说感叹词
					-- inst:Remove()
					if #ents>0 then
						for i,v in ipairs(ents) do
							if v.prefab=="cave_banana_tree" then
								--每棵香蕉树下出一只猴子
								local monkey=SpawnPrefab("monkey")
								if monkey then
									monkey.Transform:SetPosition(v.Transform:GetWorldPosition())
									SpawnPrefab("small_puff").Transform:SetPosition(v.Transform:GetWorldPosition())
									if monkey.components.combat and picker then
										monkey.components.combat:SuggestTarget(picker)
									end
								end
								needtalk=true
								--重置采摘函数，免得一直出猴子
								if v.components.pickable then
									v.components.pickable.onpickedfn=oldonpickedfn
								end
							end
						end
					end
					if needtalk and picker then
						if picker.components.talker and not picker:HasTag("mime") then
							picker.components.talker:Say(STRINGS.UNSOLVEDSPEECH.MONKEY_NEST)
						end
					end
				end
			end
		end},
	},
	yankuang={--盐矿
		{item="saltstack",num=6,radius=6,iswater=true},--盐矿
		{item="cookiecutter",num=6,radius=6,angle_offset=0.5,iswater=true},--饼干切割机
	},
	kelprevenge={--复仇海带
		--海带
		{item="bullkelp_plant",num=6,radius=5,angle_offset=0.5,iswater=true,itemfn=function(item,player)
			item:AddTag("notdevourable")--不可吞噬
			if item.components.pickable then
				local oldonpickedfn = item.components.pickable.onpickedfn
				item.components.pickable.onpickedfn=function(inst,picker)
					if oldonpickedfn then
						oldonpickedfn(inst,picker)
					end
					local x,y,z=inst.Transform:GetWorldPosition()
					local ents = TheSim:FindEntities(x, y, z, 12,{"notdevourable"} , { "INLIMBO" })
					local needtalk=false;
					-- inst:Remove()
					if #ents>0 then
						for i,v in ipairs(ents) do
							if v.prefab=="bullkelp_plant" then
								local newitem=SpawnPrefab("waterplant")
								if newitem then
									newitem.Transform:SetPosition(v.Transform:GetWorldPosition())
									if newitem.components.combat and picker then
										newitem.components.combat:SuggestTarget(picker)
									end
								end
								v:Remove()
								needtalk=true
							end
						end
					end
					if needtalk and picker then
						if picker.components.talker and not picker:HasTag("mime") then
							picker.components.talker:Say(STRINGS.UNSOLVEDSPEECH.BUJIANGWUDE) 
						end
					end
				end
			end
		end},
	},
	waterballet={--水上芭蕾
		{item="gnarwail",num=4,radius=6,angle_offset=0.5,iswater=true,noaggro=true},--一角鲸
		{item="squid",num=4,radius=6,iswater=true},--鱿鱼
	},
	haiguai={--海上影怪
		{item="oceanhorror",num=6,radius=5,iswater=true},
		{playerfn=function(player)--玩家状态函数
			if player.components.sanity~=nil then
				player.components.sanity:SetPercent(0)--精神扣完
			end
		end},
	},
	titanic={--泰坦尼克号
		{item="seastack",num=6,radius=6,iswater=true},--礁石
		{item="seastack",num=6,radius=7,angle_offset=0.5,iswater=true},--礁石
		{item="seastack",num=6,radius=8,iswater=true},--礁石
		{item="mast",num=4,radius=3,itemfn=function(item,player)
			setRandomSkinMedal(item,player)--设置皮肤
			if item.components.mast then
				item.components.mast:UnfurlSail()
			end
		end,
		specialfn=function(item,player)--特殊函数
			setRandomSkinMedal(item,player)--设置皮肤
			if item.components.mast then
				item.components.mast:UnfurlSail()
			end
			--额外掉落蓝宝石(海洋之心)
			if item.components.workable then
				local oldOnFinishFn = item.components.workable.onfinish
				item.components.workable:SetOnFinishCallback(function(inst, hammerer)
					if inst.components.lootdropper then
						inst.components.lootdropper:AddChanceLoot("bluegem", 1)
					end
					if oldOnFinishFn then
						oldOnFinishFn(inst,hammerer)
					end
				end)
			end
		end},
	},
}

local book_defs={
	{
		name="closed_book",--无字天书
		anim="closed_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.CLOSED,
		readfn=function(inst,reader)
			reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
			local talker = reader.components.talker
			if reader.components.inventory and reader.components.inventory:EquipHasTag("xinhua_dictionary") then
				--小概率触发奇遇
				if math.random() < TUNING_MEDAL.CLOSED_BOOK_SPECIAL_RATE then
					local qiyu_id=math.random(4)--奇遇编号
					local talkstr=nil--感叹词
					if qiyu_id==1 then
						--黄金屋
						talkstr=STRINGS.CLOSEDBOOKSPEECH.HUANGJINWU
						--生成黄金
						for k=1,TUNING_MEDAL.CLOSED_BOOK_GOLDNUGGET_NUM do
							inst.components.lootdropper:SpawnLootPrefab("goldnugget")
						end
					elseif qiyu_id==2 then
						--颜如玉
						talkstr=STRINGS.CLOSEDBOOKSPEECH.YANRUYU
						local x, y, z = reader.Transform:GetWorldPosition()
						local pigman = SpawnPrefab("merm")
						pigman.Transform:SetPosition(x, y, z)
					elseif qiyu_id==3 then
						--千钟粟
						talkstr=STRINGS.CLOSEDBOOKSPEECH.QIANZHONGSU
						for k=1,TUNING_MEDAL.CLOSED_BOOK_SEEDS_NUM do
							inst.components.lootdropper:SpawnLootPrefab("seeds")
						end
					else
						--车马簇
						talkstr=STRINGS.CLOSEDBOOKSPEECH.CHEMACU
						inst.components.lootdropper:SpawnLootPrefab("chesspiece_knight_marble")
						inst.components.lootdropper:SpawnLootPrefab("chesspiece_knight_stone")
						inst.components.lootdropper:SpawnLootPrefab("chesspiece_knight_moonglass")
						inst.components.lootdropper:SpawnLootPrefab("chesspiece_rook_marble")
						inst.components.lootdropper:SpawnLootPrefab("chesspiece_rook_stone")
						inst.components.lootdropper:SpawnLootPrefab("chesspiece_rook_moonglass")
					end
					if talker and talkstr and not reader:HasTag("mime") then
						talker:Say(talkstr)
					end
				end
			end
			
			return true
		end,
		perusefn = function(inst,reader)
            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(STRINGS.SHUDAIZISPEECH.CLOSED)           
            return true
        end, 
	},
	{
		name="immortal_book",--不朽之谜
		anim="immortal_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.IMMORTAL,
		radius=TUNING_MEDAL.BOOK_NORMAL_RADIUS,--作用范围
		taglist={"fate_rewriteable"},--可改命
		readfn=function(inst,reader)
			reader.components.sanity:SetPercent(0)
			if reader and reader.components.inventory then
				--不朽之谜列表
				local immortal_loot={
					loot1={--初始
						{key="bundlewrap",weight=4},--捆绑包装纸
						{key="beeswax",weight=1},--蜂蜡
						{key="bearger_chest_blueprint",weight=5},--熊皮宝箱蓝图
					},
					loot2={--学过熊皮宝箱
						{key="bundlewrap",weight=3},--捆绑包装纸
						{key="beeswax",weight=1},--蜂蜡
						{key="immortal_gem_blueprint",weight=3},--不朽宝石蓝图
						{key="immortal_essence",weight=1},--不朽精华
						{key="immortal_fruit",weight=2},--不朽果实
					},
					loot3={--学过不朽宝石
						{key="bundlewrap",weight=3},--捆绑包装纸
						{key="beeswax",weight=1},--蜂蜡
						{key="immortal_fruit_seed",weight=1},--不朽种子
						{key="immortal_essence",weight=1},--不朽精华
						{key="immortal_fruit",weight=4},--不朽果实
					},
				}
				--学过熊皮宝箱蓝图
				if reader.components.builder and reader.components.builder:KnowsRecipe("bearger_chest") then
					--学过不朽宝石蓝图
					if reader.components.builder:KnowsRecipe("immortal_gem") then
						inst.components.lootdropper:SpawnLootPrefab(GetMedalRandomItem(immortal_loot.loot3,inst.medal_destiny_num))
					else
						inst.components.lootdropper:SpawnLootPrefab(GetMedalRandomItem(immortal_loot.loot2,inst.medal_destiny_num))
					end
				else--没学过熊皮宝箱蓝图
					inst.components.lootdropper:SpawnLootPrefab(GetMedalRandomItem(immortal_loot.loot1,inst.medal_destiny_num))
				end
				
				
				--额外作用
				local x, y, z = reader.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_NORMAL_RADIUS,nil , { "INLIMBO"},{"ignorewalkableplatforms","diseased"})
				if #ents>0 then
					for i,v in ipairs(ents) do
						--加速盐矿生长
						if v.prefab=="saltstack" and math.random()<0.5 then
							v:PushEvent("timerdone", { name = "growth" })
						end
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(STRINGS.SHUDAIZISPEECH.IMMORTAL)           
            return true
        end,
		extrafn = function(inst)--主机额外扩展函数
			if not inst.medal_destiny_num then
				inst.medal_destiny_num=math.random()--命运数字
			end
		end,
	},
	{
		name="monster_book",--怪物图鉴
		anim="monster_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.MONSTER,
		radius=TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,--作用范围
		taglist={"fate_rewriteable"},--可改命
		readfn=function(inst,reader)
			reader.components.sanity:SetPercent(0)
			local x, y, z = reader.Transform:GetWorldPosition()
			local ents=nil
			local monster=nil
			--判断玩家在船上或者在水面上
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				-- monster=SpawnPrefab("malbatross")
				local monster_code = doSacrifice(inst,reader,chesspiece_list.water,monster_loot.water)--进行献祭并获取随机怪物ID
				monster=SpawnPrefab(monster_code)--生成怪物
			else
				local monster_code = doSacrifice(inst,reader,chesspiece_list.land,monster_loot.land)--进行献祭并获取随机怪物ID
				monster=SpawnPrefab(monster_code)--生成怪物
			end
			if monster~=nil then
				monster.Transform:SetPosition(x, y, z)
				if monster.components.combat then
					monster.components.combat:SuggestTarget(reader)
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
            reader.components.talker:Say(STRINGS.SHUDAIZISPEECH.MONSTER)           
            return true
        end, 
		extrafn = function(inst)--主机额外扩展函数
			if not inst.medal_destiny_num then
				inst.medal_destiny_num=math.random()--命运数字
			end
		end,
	},
	{
		name="unsolved_book",--未解之谜
		anim="unsolved_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.UNSOLVED,
		radius=TUNING_MEDAL.BOOK_SACRIFICE_RADIUS,--作用范围
		taglist={"fate_rewriteable"},--可改命
		readfn=function(inst,reader)
			reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
			--在船上或者水里，则生成水上奇遇
			if reader:GetCurrentPlatform() ~= nil or (reader.components.drownable~= nil and reader.components.drownable:IsOverWater()) then
				local qiyu_id = doSacrifice(inst,reader,unsolved_item_list.water,unsolved_index.water)--进行献祭并获取随机奇遇ID
				spawnCircleItem(reader,unsolved_loot[qiyu_id],STRINGS.UNSOLVEDSPEECH[string.upper(qiyu_id)])--生成水上奇遇
			else--否则生成陆地奇遇
				local qiyu_id = doSacrifice(inst,reader,unsolved_item_list.land,unsolved_index.land)--进行献祭并获取随机奇遇ID
				spawnCircleItem(reader,unsolved_loot[qiyu_id],STRINGS.UNSOLVEDSPEECH[string.upper(qiyu_id)])--生成陆地奇遇
			end
			return true
		end,
		perusefn = function(inst,reader)
            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(STRINGS.SHUDAIZISPEECH.UNSOLVED)           
            return true
        end, 
		extrafn = function(inst)--主机额外扩展函数
			if not inst.medal_destiny_num then
				inst.medal_destiny_num=math.random()--命运数字
			end
		end,
	},
	{
		name="trapreset_book",--陷阱重置册
		anim="trapreset_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.TRAPRESET,
		radius=TUNING_MEDAL.BOOK_NORMAL_RADIUS,--作用范围
		readfn=function(inst,reader)
			reader.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
			local x, y, z = reader.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_NORMAL_RADIUS,nil , { "INLIMBO"})
			if #ents>0 then
				for i,v in ipairs(ents) do
					if v.prefab=="trap_teeth" then
						if v.components.mine and v.components.mine.issprung then 
							v.components.mine:Reset()
						end
					elseif v.prefab=="trap_bramble" then
						if v.components.mine and v.components.mine.issprung then 
							v.components.mine:Reset()
						end
					elseif v.prefab=="trap_bat" then
						if v.components.mine and v.components.mine.issprung then 
							v.components.mine:Reset()
						end
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            reader.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
            reader.components.talker:Say(STRINGS.SHUDAIZISPEECH.TRAPRESET)           
            return true
        end, 
	},
	{
		name="autotrap_book",--智能陷阱制作手册
		anim="autotrap_book",
		uses=TUNING_MEDAL.BOOK_MAXUSES.AUTOTRAP,
		radius=TUNING_MEDAL.BOOK_NORMAL_RADIUS,--作用范围
		readfn=function(inst,reader)
			reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
			local x, y, z = reader.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, TUNING_MEDAL.BOOK_NORMAL_RADIUS,{"trap"} , { "INLIMBO"})
			if #ents>0 then
				local autovalue=30--升级点数
				for i,v in ipairs(ents) do
					if v.setAutoTrap and not v:HasTag("autoTrap") then
						v:setAutoTrap()
						spawnFX("collapse_small",v)
						--升级荆棘陷阱消耗2点点数，其他消耗1点
						if v.prefab=="trap_bramble" then
							autovalue=autovalue-2
						else
							autovalue=autovalue-1
						end
						if autovalue<=0 then
							break
						end
					end
				end
			end
			return true
		end,
		perusefn = function(inst,reader)
            reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
            reader.components.talker:Say(STRINGS.SHUDAIZISPEECH.AUTOTRAP)           
            return true
        end,  
	},
}

return book_defs