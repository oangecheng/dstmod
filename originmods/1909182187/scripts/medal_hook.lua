--勋章特有容器列表(封装在表里方便做兼容)
local special_medal_box={
	medal_box=true,--勋章盒
	-- spices_box=true,--调料盒
	medal_ammo_box=true,--弹药盒
	medal_krampus_chest_item=true,--坎普斯之匣
}
---------------------------------------------------------------------------------------------------------
----------------------------------------------复用函数---------------------------------------------------
---------------------------------------------------------------------------------------------------------
--获取堆叠数量
local function GetStackSize(item)
    return item.components.stackable ~= nil and item.components.stackable:StackSize() or 1
end
---------------------------------------------------------------------------------------------------------
--------------------------------------------不朽之力相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--使预置物拥有不朽能力
local function setCanBeImmortal(inst)
	inst:AddTag("canbeimmortal")--可被赋予不朽之力
	inst.immortalchangename = GLOBAL.net_bool(inst.GUID, "immortalchangename", "immortalchangenamedirty")
	inst:ListenForEvent("immortalchangenamedirty", function(inst)
		if inst:HasTag("keepfresh") then
			if inst.immortalchangename:value() then
				--加上不朽前缀
				inst.displaynamefn = function(aaa)
					return subfmt(STRINGS.NAMES["IMMORTAL_BACKPACK"], { backpack = STRINGS.NAMES[string.upper(inst.prefab)] })
				end
			end
		end
	end)
	if GLOBAL.TheNet:GetIsServer() then
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		--赋予不朽之力
		inst.setImmortal=function(inst)
			inst:AddTag("keepfresh")
			if inst.components.preserver==nil then
				inst:AddComponent("preserver")
			end
			inst.components.preserver:SetPerishRateMultiplier(function(inst, item)
				return (item ~= nil and not (item:HasTag("fish") or item.components.health~=nil)) and 0 or nil
			end)
			inst.immortalchangename:set(true)--修改名字
		end
		inst.OnSave = function(inst,data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			if inst:HasTag("keepfresh") then
				data.immortal=true
			end
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil and data.immortal then
				if inst.setImmortal then
					inst.setImmortal(inst)
				end
			end
		end
	end
end

--可添加不朽之力的容器列表
local immortal_loot={
	"icebox",--冰箱
	"saltbox",--盐盒
	"medal_farm_plow_item",--高效耕地机
	--想让什么不朽自己加，但不保证都能正常使用哦~
	-- "treasurechest",--箱子
	-- "medal_livingroot_chest",--树根宝箱
}
--添加不朽之力
for k,v in ipairs(immortal_loot) do
	AddPrefabPostInit(v,setCanBeImmortal)
end
---------------------------------------------------------------------------------------------------------
--------------------------------------------新掉落物相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--需添加掉落物的预置物列表
local lootdropper_loot={
	krampus={--坎普斯:坎普斯之灵
		krampus_soul=TUNING_MEDAL.KRAMPUS_SOUL_DROP_RATE,
	},
	spoiled_fish={--腐烂的鱼:鱼骨
		medal_fishbones=0.75,
	},
	spoiled_fish_small={--腐烂的小鱼:鱼骨
		medal_fishbones=0.5,
	},
	statueglommer={--格罗姆雕像:淘气勋章
		naughty_certificate=1,
	},
}
for k,v in pairs(lootdropper_loot) do
	AddPrefabPostInit(k,function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.lootdropper then
				for ik,iv in pairs(v) do
					inst.components.lootdropper:AddChanceLoot(ik, iv)
				end
			end
		end
	end)
end

---------------------------------------------------------------------------------------------------------
----------------------------------------------正义值相关--------------------------------------------------
---------------------------------------------------------------------------------------------------------
--预制物可补充的正义值
local justice_value_loot={
	monstermeat=2,--怪物肉
	cookedmonstermeat=2,--烤怪物肉
	monstermeat_dried=4,--怪物肉干
	durian=4,--榴莲
	durian_cooked=4,--烤榴莲
	monsterlasagna=6,--怪物千层饼
	monstertartare=8,--怪物鞑靼
	medal_monster_essence=25,--怪物精华
}
for k,v in pairs(justice_value_loot) do
	AddPrefabPostInit(k,function(inst)
		inst:AddTag("addjustice")--可增加正义值
		if GLOBAL.TheWorld.ismastersim then
			inst.addjustice_value=v--可增加的正义值
		end
	end)
end
---------------------------------------------------------------------------------------------------------
---------------------------------------------月光移植相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
local SORTED_FERTILIZERS = require("prefabs/fertilizer_nutrient_defs").SORTED_FERTILIZERS
FERTILIZER_DEFS.spice_poop = {--秘制酱料肥料
	nutrients = {8,16,8},
	inventoryimage="spice_poop.tex",
	atlas="images/spice_poop.xml",
	name="SPICE_POOP",
	uses=1,
}
table.insert(SORTED_FERTILIZERS,"spice_poop")

--可进行月光移植的植物(key作物名,value产物数量)
local transplant_loot={
	reeds = 1,--芦苇
	flower_cave = 1,--荧光果
	cactus = 1,--仙人掌
	oasis_cactus = 1,--沙漠仙人掌
	lichen = 1,--洞穴苔藓
	wormlight_plant = 1,--神秘植物
	flower_cave_double = 2,--双果荧光果
	flower_cave_triple = 3,--三果荧光果
	lightflier_flower = 0,--荧光虫花
}
--设置移植函数
local function setTransplantFn(inst,numproduct)
	if inst.components.workable == nil then
		inst:AddComponent("workable")
	end
	if inst.components.lootdropper == nil then
		inst:AddComponent("lootdropper")
	end
	inst.components.workable:SetWorkAction(ACTIONS.MEDALTRANSPLANT)--月光移植动作
	inst.components.workable:SetOnWorkCallback(function(inst,worker)--移植回调
		if inst.components.pickable ~= nil and inst.components.lootdropper ~= nil then
			if inst.components.pickable:CanBePicked() then
				--如果可采摘，则多掉落对应数量的产物
				if numproduct>0 then
					for i=1,numproduct do
						inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
					end
				elseif inst.components.childspawner and inst.components.childspawner.childname then
					inst.components.lootdropper:SpawnLootPrefab(inst.components.childspawner.childname)
				end
				--如果有花，则产物里多一个仙人掌花
				if inst.has_flower then
					inst.components.lootdropper:SpawnLootPrefab("cactus_flower")--仙人掌花
				end
			end
			inst.components.lootdropper:SpawnLootPrefab("medaldug_"..inst.prefab)--生成移植树苗
		end
		inst:Remove()
	end)
	inst.components.workable:SetWorkLeft(1)--需要铲1下
	
	if inst.components.pickable then
		--设置移植函数,移植后可直接用铲子挖
		inst.components.pickable.ontransplantfn = function(inst)
			inst.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)--不需要月光的移植动作
			inst:RemoveTag("cantdestroy")
			--芦苇魔法免疫
			if inst.prefab=="reeds" then
				inst:AddTag("showmedalinfo")
				inst.components.pickable.magic_immunity=0
			end
			if inst.NeedFertilizeFn then
				inst:NeedFertilizeFn()
			end
		end
		--双果荧光花的缺肥动画缺失，这里强行给它修一波
		if inst.prefab=="flower_cave_double" then
			local oldonpickedfn=inst.components.pickable.onpickedfn
			inst.components.pickable.onpickedfn = function(inst)
				if oldonpickedfn then
					oldonpickedfn(inst)
				end
				if inst.components.pickable:IsBarren() then
					inst.AnimState:PlayAnimation("picking")
					inst.AnimState:PushAnimation("picked")
				end
			end
		end
	end
	--需施肥函数
	inst.NeedFertilizeFn=function(inst)
		inst:AddTag("needfertilize")--需施肥
		inst.components.pickable:Pause()--暂停生长
		inst.AnimState:SetMultColour(0.5, 0.45, 0.3, 1)
	end
	--施肥函数
	inst.AddFertilizeFn=function(inst)
		inst:RemoveTag("needfertilize")
		if inst.prefab=="reeds" or inst.prefab=="lichen" then
			--芦苇和洞穴苔藓冬天不要生长
			if not TheWorld.state.iswinter then
				inst.components.pickable:Resume()--继续生长
			end
		else
			inst.components.pickable:Resume()--继续生长
		end
		inst.AnimState:SetMultColour(1, 1, 1, 1)
	end
	
	--加载时判断是否是移植过的植物
	local oldPreLoadFn=inst.OnPreLoad
	inst.OnPreLoad=function(inst, data)
		if data ~= nil and data.pickable ~= nil and data.pickable.transplanted then
			inst.components.workable:SetWorkAction(ACTIONS.MEDALNORMALTRANSPLANT)
			inst:RemoveTag("cantdestroy")
			--芦苇魔法免疫
			if inst.prefab=="reeds" and inst.components.pickable.magic_immunity==nil then
				inst:AddTag("showmedalinfo")
				inst.components.pickable.magic_immunity=0
			end
		end
		if oldPreLoadFn then
			oldPreLoadFn(inst,data)
		end
	end
	
	local oldSaveFn=inst.OnSave
	inst.OnSave=function(inst,data)
		if inst:HasTag("needfertilize") then
			data.needfertilize=true
		end
		if oldSaveFn then
			oldSaveFn(inst,data)
		end
	end
	local oldLoadFn=inst.OnLoad
	inst.OnLoad=function(inst,data)
		if data and data.needfertilize then
			if inst.NeedFertilizeFn then
				inst:NeedFertilizeFn()--需施肥
			end
			-- inst:AddTag("needfertilize")--需施肥
		end
		if oldLoadFn then
			oldLoadFn(inst,data)
		end
	end
end

--如果开启了移植功能
if TUNING.TRANSPLANT_OPEN then
	for k,v in pairs(transplant_loot) do
		AddPrefabPostInit(k,function(inst)
			inst:AddTag("cantdestroy")--不可破坏(防止熊大、地震等对其造成破坏)
			inst:AddTag("medal_transplant")--特殊移植作物
			if GLOBAL.TheWorld.ismastersim then
				setTransplantFn(inst,v)--设置移植函数
			end
		end)
	end
end

---------------------------------------------------------------------------------------------------------
--------------------------------------------月光破坏相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--可破坏建筑(key预置物名,value破坏后的产物)
local medalhammer_loot={
	minotaurchest = {"boards","boards","boards","goldnugget","goldnugget"},--远古守卫者箱子
	insanityrock = {"sanityrock_fragment","marble","nightmarefuel"},--方尖碑
	sanityrock = {"sanityrock_fragment","marble","nightmarefuel"},--反向方尖碑
	gravestone = {"marble","marble"},--墓碑
	basalt = {"marble","marble","marble","marble"},--玄武岩
	basalt_pillar = {"marble","marble","marble"},--高玄武岩
}

--设置敲打函数
local function setHammerFn(inst,droplist)
	if inst.components.workable == nil then
		inst:AddComponent("workable")
	end
	if inst.components.lootdropper == nil then
		inst:AddComponent("lootdropper")
	end
	inst.components.workable:SetWorkAction(ACTIONS.MEDALHAMMER)--专属敲击动作
	--设置敲破时执行的函数
	inst.components.workable:SetOnFinishCallback(function(inst,worker)
		if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
			inst.components.burnable:Extinguish()
		end
		if inst.components.lootdropper then
			if droplist and #droplist>0 then
				for i, v in ipairs(droplist) do
					inst.components.lootdropper:SpawnLootPrefab(v)
				end
			end
		end
		if inst.components.container ~= nil then
			inst.components.container:DropEverything()
		end
		local fx = SpawnPrefab("collapse_small")
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		fx:SetMaterial("wood")
		--如果是墓碑，有对应的墓地，则保留墓地只破坏墓碑
		if inst.mound and inst.mound.Transform:GetWorldPosition() then
			local newmound=SpawnPrefab(inst.mound.prefab)
			newmound.Transform:SetPosition(inst.mound.Transform:GetWorldPosition())
			if not inst.mound.components.workable then
				newmound.AnimState:PlayAnimation("dug")
				newmound:RemoveComponent("workable")
			end
		end
		--移除墓碑绑定的小惊吓
		if inst.ghost then
			inst.ghost:Remove()
		end
		inst:Remove()
	end)
	--设置敲击时执行的函数
	inst.components.workable:SetOnWorkCallback(function(inst,worker)
		if not inst:HasTag("burnt") then
			inst.AnimState:PlayAnimation("hit")
			inst.AnimState:PushAnimation("closed", false)
			if inst.components.container ~= nil then
				inst.components.container:DropEverything()
				inst.components.container:Close()
			end
		end
	end)
	inst.components.workable:SetWorkLeft(1)--需要敲1下
	
	--修改墓碑的存储函数，防止被挖过的坟再次生成
	if inst.prefab=="gravestone" then
		local oldSaveFn=inst.OnSave
		inst.OnSave=function(inst,data)
			if inst.mound==nil then
				data.nomound=true
			end
			return oldSaveFn and oldSaveFn(inst,data)
		end
		local oldLoadFn=inst.OnLoad
		inst.OnLoad=function(inst,data)
			if data and inst.mound and data.nomound then
				inst.mound:Remove()
				inst.mound=nil
			end
			if oldLoadFn then
				oldLoadFn(inst,data)
			end
		end
	end
end 

for k,v in pairs(medalhammer_loot) do
	AddPrefabPostInit(k,function(inst)
		inst:AddTag("cantdestroy")--不可破坏(防止熊大、地震等对其造成破坏)
		if GLOBAL.TheWorld.ismastersim then
			setHammerFn(inst,v)--设置敲打函数
		end
	end)
end

---------------------------------------------------------------------------------------------------------
--------------------------------------------修改世界相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------
--给地上世界添加记录组件
AddPrefabPostInit("forest",function(inst)
	if inst.ismastersim then
		inst:AddComponent("medal_infosave")
	end
end)

--给世界添加传送塔注册组件
AddPrefabPostInit("world",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("medal_townportalregistry")
	end
end)
---------------------------------------------------------------------------------------------------------
--------------------------------------------修改玩家相关-------------------------------------------------
---------------------------------------------------------------------------------------------------------

--复眼滤镜
local OMMATEUM_COLOURCUBES ={
	-- day = "images/colour_cubes/purple_moon_cc.tex",
	-- dusk = "images/colour_cubes/purple_moon_cc.tex",
	-- night = "images/colour_cubes/purple_moon_cc.tex",
	-- full_moon = "images/colour_cubes/purple_moon_cc.tex",
	day = "images/colour_cubes/spring_day_cc.tex",
	dusk = "images/colour_cubes/spring_dusk_cc.tex",
	night = "images/colour_cubes/purple_moon_cc.tex",
	full_moon = "images/colour_cubes/purple_moon_cc.tex",
}
--复眼函数
local function SetOmmateumVision(inst)
	local isequipped = inst.medalnightvision:value()
	if isequipped then
		if inst.components.playervision then
			inst.components.playervision:ForceNightVision(true)
			inst.components.playervision:ForceGoggleVision(true)
			inst.components.playervision:SetCustomCCTable(OMMATEUM_COLOURCUBES)
		end
	else
		if inst.components.playervision then
			inst.components.playervision:ForceNightVision(false)
			inst.components.playervision:ForceGoggleVision(false)
			inst.components.playervision:SetCustomCCTable(nil)
		end
	end
end

--谋杀鱼函数
local function OnMurderedFish(inst, data)
    local victim = data.victim
    if victim ~= nil then
		--海鱼
		if victim:HasTag("oceanfish") then
			--时令鱼
			if victim.prefab=="oceanfish_small_7_inv" or victim.prefab=="oceanfish_small_6_inv" or victim.prefab=="oceanfish_small_8_inv" or victim.prefab=="oceanfish_medium_8_inv" then
				--判断玩家是否已经学习过船上钓鱼池蓝图
				if inst.components.builder and not inst.components.builder:KnowsRecipe("medal_seapond") then
					victim.components.lootdropper:SpawnLootPrefab("medal_seapond_blueprint")
					if inst.components.talker and not inst:HasTag("mime") then
						inst.components.talker:Say(STRINGS.PLACECHUMSPEECH.GETBLUEPRINT)
					end
				end
			else--其他海鱼
				if math.random()<TUNING_MEDAL.SEAPOND_BLUEPRINT_CHANCE then
					--判断玩家是否已经学习过船上钓鱼池蓝图
					if inst.components.builder and not inst.components.builder:KnowsRecipe("medal_seapond") then
						victim.components.lootdropper:SpawnLootPrefab("medal_seapond_blueprint")
						if inst.components.talker and not inst:HasTag("mime") then
							inst.components.talker:Say(STRINGS.PLACECHUMSPEECH.GETBLUEPRINT)
						end
					end
				end
			end
		--熔岩鳗鱼
		elseif victim.prefab=="lavaeel" then
			if victim.components.lootdropper then
				for k=1,3 do
					victim.components.lootdropper:FlingItem(SpawnPrefab("houndfire"), victim:GetPosition())
				end
			end
		end
    end
end

--设置灵魂跳跃函数
local function setBlinkFn(player)
	if player.components.playeractionpicker ~= nil then
		local old_pointspecialactionsfn = player.components.playeractionpicker.pointspecialactionsfn
		if old_pointspecialactionsfn then
			--有老函数的需要判断是不是第一次调用，只有第一次调用生效
			if not player.setBlink_flag then
				player.setBlink_flag=true--设置pointspecialactionsfn的标记，防止多次套用
				player.components.playeractionpicker.pointspecialactionsfn=function(inst, pos, useitem, right)
					--拥有临时穿梭者、自由穿梭者、勋章穿梭者标签
					if right and useitem == nil and (inst.replica.rider == nil or not inst.replica.rider:IsRiding()) then
						if inst:HasTag("temporaryblinker") or inst:HasTag("freeblinker") or inst:HasTag("medal_blinker") then
							return { ACTIONS.BLINK }
						end
					end
					return old_pointspecialactionsfn(inst, pos, useitem, right)
				end
			end
		else--没老函数的直接赋值新函数，伍迪这种每次被清空的就是nil，直接套就完事了(不需要考虑鸭子状态)
			player.setBlink_flag=true--设置pointspecialactionsfn的标记，防止多次套用
			player.components.playeractionpicker.pointspecialactionsfn=function(inst, pos, useitem, right)
				--拥有临时穿梭者、自由穿梭者、勋章穿梭者标签
				if right and useitem == nil and (inst.replica.rider == nil or not inst.replica.rider:IsRiding()) then
					if inst:HasTag("temporaryblinker") or inst:HasTag("freeblinker") or inst:HasTag("medal_blinker") then
						return { ACTIONS.BLINK }
					end
				end
				return {}
			end
		end
	end
end
--设置玩家减速触发器(蜘蛛网)
local function setTriggerscreepFn(player)
	if player.medaltriggerscreep:value() then
		--在蜘蛛网上走路不减速
		if player.components.locomotor and player.components.locomotor.triggerscreep==true then
			player.components.locomotor:SetTriggersCreep(false)
		end
	elseif player.components.locomotor then
		player.components.locomotor:SetTriggersCreep(true)
	end
end
--玩家初始化
AddPlayerPostInit(function(inst)
	inst.medalnightvision = GLOBAL.net_bool(inst.GUID, "medalnightvision", "medalnightvisiondirty")
	inst:ListenForEvent("medalnightvisiondirty", SetOmmateumVision)--复眼勋章
	inst:AddTag("trap_immunity")--免疫陷阱标签
	inst.AnimState:AddOverrideBuild("player_transform_merm")
	inst.medalblinkable = GLOBAL.net_bool(inst.GUID, "medalblinkable", "medalblinkabledirty")
	inst:ListenForEvent("medalblinkabledirty", setBlinkFn)--灵魂跳跃
	inst.medalblinkable:set(true)
	inst.medaltriggerscreep = GLOBAL.net_bool(inst.GUID, "medaltriggerscreep", "medaltriggerscreepdirty")
	inst:ListenForEvent("medaltriggerscreepdirty", setTriggerscreepFn)--设置玩家减速触发器
	--饱食额外下降速率
	inst.medal_hungerrate = GLOBAL.net_float(inst.GUID, "medal_hungerrate","medal_hungerratedirty")
	--拖拽后坐标
	inst.medal_drag_pos = GLOBAL.net_string(inst.GUID, "medal_drag_pos", "medal_drag_posdirty")
	--食物列表
	inst.medal_food_list = GLOBAL.net_string(inst.GUID, "medal_food_list", "medal_food_listdirty")
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("murdered", OnMurderedFish)--谋杀鱼
		--存储拖拽坐标数据
		local oldOnSaveFn=inst.OnSave
		local oldOnLoadFn=inst.OnLoad
		inst.OnSave=function(inst,data)
			data.dragtypepos=inst.medal_drag_pos:value()
			if oldOnSaveFn then
				oldOnSaveFn(inst,data)
			end
		end
		inst.OnLoad=function(inst,data)
			if data.dragtypepos then
				inst.medal_drag_pos:set(data.dragtypepos)
			end
			if oldOnLoadFn then
				oldOnLoadFn(inst,data)
			end
		end
	end
end)

AddPrefabPostInit("player_classified",function(inst)
	--添加物品详细信息
	if TUNING.SHOW_MEDAL_INFO then
		inst.medal_info = ""--详细信息
		inst.net_medal_info = _G.net_string(inst.GUID, "medal_info", "medal_infodirty")
	end
	--获取玩家视角方向
	inst.medalcameraheading = _G.net_shortint(inst.GUID, "medalcameraheading", "medalcameraheadingdirty")
	inst.medalcameraheading:set(45)--默认视角方向
	inst.net_medal_camera_heading = _G.net_bool(inst.GUID, "medal_camera_heading", "medal_camera_headingdirty")
	--玩家是否受到蜂毒伤害
	inst.medal_injured = _G.net_bool(inst.GUID, "medal_injured", "medal_injureddirty")
	
	if TheNet:GetIsClient() or (TheNet:GetIsServer() and not TheNet:IsDedicated()) then
		--添加物品详细信息
		if TUNING.SHOW_MEDAL_INFO then
			inst:ListenForEvent("medal_infodirty",function(inst)
				inst.medal_info = inst.net_medal_info:value()
			end)
		end
		--通过网络变量对客机发起数据同步请求，获取到视角方向后再同步给主机
		inst:ListenForEvent("medal_camera_headingdirty",function(inst)
			if TheCamera then
				SendModRPCToServer(MOD_RPC.functional_medal.SetCameraHeading, TheCamera:GetHeadingTarget())
			end
		end)
		--玩家中蜂毒后的受伤界面显示
		inst:ListenForEvent("medal_injureddirty",function(inst)
			if inst._parent and inst._parent.HUD then
				if inst.medal_injured:value() then
					inst._parent.HUD.medal_injured:Flash()
				end
			end
		end)
	end
end)

---------------------------------------------------------------------------------------------------------
---------------------------------------------修改预制物--------------------------------------------------
---------------------------------------------------------------------------------------------------------
--给植物人增加一个活木制作者标签
AddPrefabPostInit("wormwood",function(inst)
	inst:AddTag("livinglogbuilder")
end)
--Hook小恶魔的gotnewitem事件监听
local function IsSoul(item)
    return item.prefab == "wortox_soul"
end
--把多余的灵魂掉出去
local function CheckSoulsAdded(inst)
    inst._checksoulstask = nil
    local souls = inst.components.inventory:FindItems(IsSoul)
    local count = 0
    for i, v in ipairs(souls) do
        count = count + GetStackSize(v)
    end
    if count > TUNING.WORTOX_MAX_SOULS then
    	count = count - TUNING.WORTOX_MAX_SOULS
    	local pos = inst:GetPosition()
    	for i, v in ipairs(souls) do
    	    local vcount = GetStackSize(v)
    	    if vcount < count then
    	        inst.components.inventory:DropItem(v, true, true, pos)
    	        count = count - vcount
    	    else
    	        if vcount == count then
    	            inst.components.inventory:DropItem(v, true, true, pos)
    	        else
    	            v = v.components.stackable:Get(count)
    	            v.Transform:SetPosition(pos:Get())
    	            v.components.inventoryitem:OnDropped(true)
    	        end
    	        break
    	    end
    	end
    end
end
--小恶魔佩戴噬灵勋章时谋杀小动物不会爆魂
AddPrefabPostInit("wortox",function(inst)
	local upvaluehelper = require "medal_upvaluehelper"--出自 风铃草大佬
	local OnGotNewItem = upvaluehelper.GetEventHandle(inst,"gotnewitem","prefabs/wortox")
	if OnGotNewItem then
		inst:RemoveEventCallback("gotnewitem",OnGotNewItem)
		inst:ListenForEvent("gotnewitem", function(inst,data)
			--戴了勋章的话就不要爆魂了
			if inst.medal_soulstealer then
				if data.item ~= nil and data.item.prefab == "wortox_soul" then
					if inst._checksoulstask ~= nil then
					    inst._checksoulstask:Cancel()
					end
					inst._checksoulstask = inst:DoTaskInTime(0, CheckSoulsAdded)
				end
			else
				OnGotNewItem(inst,data)
			end
		end)
	end
end)

--删除蝙蝠飞行标签
AddPrefabPostInit("bat",function(inst)
	if inst:HasTag("flying") then
		inst:RemoveTag("flying")
	end
	inst:AddTag("trap_immunity")--免疫陷阱标签
end)

--给猪人增加友情勋章的获取
AddPrefabPostInit("pigman",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.trader then
			local oldOnacceptFn=inst.components.trader.onaccept
			inst.components.trader.onaccept = function(inst, giver, item)
				if item.prefab=="taffy" then
					if giver.friendlymonster then
						giver:PushEvent("gainfriendship")
						item:Remove()--拿到糖果直接删掉，防止利用一颗糖果重复刷勋章
					end
				end
				if oldOnacceptFn~=nil then
					oldOnacceptFn(inst, giver, item)
				end
			end
		end
	end
end)

--修改食人花选择诱饵函数
AddPrefabPostInit("lureplant",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst.lurefn = function(inst)    
			if inst.components.inventory ~= nil then
				local lures = {}--诱饵列表
				--遍历食人花的容器，从容器中找到带有食人花诱饵标签的道具并加入列表
				for k = 1, inst.components.inventory.maxslots do
					local item = inst.components.inventory.itemslots[k]
					
					--移除不朽果实并生成不朽
					if item ~= nil then
						if item.prefab=="immortal_fruit" then 
							local getitem=inst.components.inventory:RemoveItem(item)
							local staff=SpawnPrefab("devour_staff")
							inst.components.inventory:GiveItem(staff)
							getitem:Remove()
							return staff
						elseif item.prefab=="immortal_gem" then
							local getitem=inst.components.inventory:RemoveItem(item)
							local staff=SpawnPrefab("immortal_staff")
							inst.components.inventory:GiveItem(staff)
							getitem:Remove()
							return staff
						elseif item.prefab=="devour_staff" or item.prefab=="immortal_staff" then 
							return item
						elseif item:HasTag("lureplant_bait") then
							table.insert(lures, item)
						end
					end
				end
				--如果诱饵列表不为空，则随机露出诱饵
				if #lures >= 1 then
					return lures[math.random(#lures)]
				--如果诱饵列表为空，并且眼球草的数量超过最大数量的一半时，就生成叶肉
				elseif inst.components.minionspawner.numminions * 2 >= inst.components.minionspawner.maxminions then
					local meat = SpawnPrefab("plantmeat")
					inst.components.inventory:GiveItem(meat)
					return meat
				end
			end
		end
		--hook食人花的采摘函数，采摘时推送事件给玩家(食人花手杖用)
		if inst.components.shelf then
			local oldontakeitemfn=inst.components.shelf.ontakeitemfn
			inst.components.shelf.ontakeitemfn=function(inst,taker)
				--如果有诱饵，并且诱饵是叶肉，则给玩家推送拿取叶肉事件
				if inst.lure and inst.lure.prefab and inst.lure.prefab=="plantmeat" then
					taker:PushEvent("takesomething", { object = inst })
				end
				if oldontakeitemfn then
					oldontakeitemfn(inst,taker)
				end 
			end
		end
	end
end)

--给岩浆池添加钓鱼组件
AddPrefabPostInit("lava_pond",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.fishable==nil then
			inst:AddComponent("fishable")
		end
		inst.components.fishable:SetRespawnTime(TUNING_MEDAL.LAVAEEL_RESPAWN_TIME)--重生时间
		inst.components.fishable:AddFish("lavaeel")--设置鱼的品种
		inst.components.fishable.maxfish=TUNING_MEDAL.LAVAEEL_MAX_NUM--设置最大容量
		inst.components.fishable.fishleft=TUNING_MEDAL.LAVAEEL_MAX_NUM--/2--设置初始数量
	end
end)

--给格罗姆添加可喂食功能，吃诱人香蕉冰后多拉粑粑
AddPrefabPostInit("glommer",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.periodicspawner then
			-- inst.components.periodicspawner:SetRandomTimes(10,5)--加快吐粘液速度，测试用
			local oldonspawn = inst.components.periodicspawner.onspawn
			inst.components.periodicspawner:SetOnSpawnFn(function(inst,fuel)
				if oldonspawn then
					oldonspawn(inst,fuel)
				end
				if inst.is_diarrhea then
					if fuel and fuel.components.stackable then
						fuel.components.stackable:SetStackSize(math.min(fuel.components.stackable:StackSize()+math.random(1,2),fuel.components.stackable.maxsize))
						inst.is_diarrhea=nil
					end
				end
			end)
		end
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		inst.OnSave = function(inst,data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			if inst.is_diarrhea then
				data.is_diarrhea=true
			end
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil and data.is_diarrhea then
				inst.is_diarrhea=data.is_diarrhea
			end
		end
	end
end)

--给月相盘加个标记
local function moondialInFullmoon(inst,isfullmoon)
	if isfullmoon and not TheWorld.state.isalterawake then
		inst:AddTag("cansalvage")--可打捞标记
	else
		inst:RemoveTag("cansalvage")
	end
end

AddPrefabPostInit("moondial",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:WatchWorldState("isfullmoon", moondialInFullmoon)--监听月圆
		--月圆并且处于非结冰状态则可捞月
		moondialInFullmoon(inst,TheWorld.state.isfullmoon)
	end
end)

--------------------------------------修改灵魂碰撞玩家时函数----------------------------------------------
--勋章获取到灵魂时执行的函数
local function medalGetSoul(inst, attacker, target)
	--获取玩家勋章
	local medal=target.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
	local adduses=false--是否添加耐久
	local x, y, z = inst.Transform:GetWorldPosition()
	local fx = SpawnPrefab("wortox_soul_in_fx")
	fx.Transform:SetPosition(x, y, z)
	fx:Setup(target)
	if medal then
		--如果是融合勋章则从融合勋章里取对应勋章
		if medal:HasTag("multivariate_certificate") and medal.components.container then
			local newmedal=medal.components.container:FindItem(function(item)
				return item.prefab=="devour_soul_certificate"
			end)
			if newmedal then
				medal=newmedal
			end
		end
		if medal.prefab=="devour_soul_certificate" then
			if medal.components.finiteuses then
				local uses=medal.components.finiteuses:GetUses()
				if uses<TUNING_MEDAL.DEVOUR_SOUL_MEDAL.MAXUSES then
					medal.components.finiteuses:SetUses(uses+1)--设置耐久
					adduses=true
				end
			end
		end
	end
	--如果没添加为耐久并且是沃拓克斯，则直接原地掉落
	if target.prefab=="wortox" and not adduses then
		fx = SpawnPrefab("wortox_soul")
		fx.Transform:SetPosition(x, y, z)
		fx.components.inventoryitem:OnDropped(true)
	end
	inst:Remove()
end

--修改灵魂碰撞玩家时的函数
AddPrefabPostInit("wortox_soul_spawn",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.projectile then
			local oldHitFn=inst.components.projectile.onhit
			inst.components.projectile:SetOnHitFn(function(inst, attacker, target)
				if target~=nil and target.medal_soulstealer then
					local souls = target.components.inventory:FindItems(function(item) 
							return item.prefab == "wortox_soul" 
						end)--获取玩家身上灵魂
					local count = 0--灵魂数量
					--灵魂上限
					local maxsoulsnum = target.prefab=="wortox" and TUNING.WORTOX_MAX_SOULS or 10
					for i, v in ipairs(souls) do
						count = count + GetStackSize(v)
					end
					--灵魂超标了才给勋章加耐久
					if count >= maxsoulsnum then
						medalGetSoul(inst, attacker, target)
						return
					end
				end
				if oldHitFn ~= nil then
					oldHitFn(inst, attacker, target)
				end
			end)
		end
	end
end)

--------------------------------------给曼德拉草加入曼德拉果产出----------------------------------------------
--开始掉落
local function StartSpawnPollen(inst)
	if inst.components.periodicspawner then
		inst.components.periodicspawner:Start()
	end
end
--停止掉落
local function StopSpawnPollen(inst)
	if inst.components.periodicspawner then
		inst.components.periodicspawner:Stop()
	end
end

AddPrefabPostInit("mandrake_active",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("periodicspawner")
        inst.components.periodicspawner:SetPrefab("mandrake_berry")--设置掉落物
        inst.components.periodicspawner:SetRandomTimes(TUNING_MEDAL.MANDARK_BERRY_SPAWNER_TIME, 1, true)--掉落周期
		inst:ListenForEvent("startfollowing", StartSpawnPollen)
		inst:ListenForEvent("stopfollowing", StopSpawnPollen)
	end
end)

---------------------------------------------智能陷阱-------------------------------------------------
--升级成自动陷阱
local function setAutoTrap(inst)
	inst:AddTag("autoTrap")
	inst.medaltrapchangename:set(true)--名字加前缀
	--自动重置
	local oldOnExplode=inst.components.mine and inst.components.mine.onexplode
	if oldOnExplode then
		inst.components.mine:SetOnExplodeFn(function(inst,target)
			oldOnExplode(inst,target)
			--在水里不自动重置
			local x,y,z=inst.Transform:GetWorldPosition()
			if not TheWorld.Map:IsOceanAtPoint(x, y, z) then
				if inst.auto_task then
					inst.auto_task:Cancel()
					inst.auto_task=nil
				end
				inst.auto_task = inst:DoTaskInTime(TUNING_MEDAL.AUTOTRAP_RESET_TIME, function(inst)
					if inst.components.mine and inst.components.mine.issprung then
						inst.components.mine:Reset()
					end
					inst.auto_task=nil
				end)
			end
		end)
	end
	--加载时如果处于触发后状态，则直接重置
	if inst.components.mine and inst.components.mine.issprung then
		inst.components.mine:Reset()
	end
	if inst.components.finiteuses then
		--荆棘陷阱移除耐久，狗牙陷阱重置次数
		if inst.prefab=="trap_bramble" then
			inst:RemoveComponent("finiteuses")
		else
			inst.components.finiteuses:SetUses(TUNING.TRAP_TEETH_USES)
		end
	end
end
--hook陷阱
local function medalHookTrap(inst)
	inst.medaltrapchangename = GLOBAL.net_bool(inst.GUID, "medaltrapchangename", "medaltrapchangenamedirty")
	inst:ListenForEvent("medaltrapchangenamedirty", function(inst)
			if inst:HasTag("autoTrap") and inst.medaltrapchangename:value() then
				--加上智能前缀
				inst.displaynamefn = function(aaa)
					return subfmt(STRINGS.NAMES["MEDAL_AUTO_TRAP"], { trap = STRINGS.NAMES[string.upper(inst.prefab)] })
				end
			end
		end)
	if GLOBAL.TheNet:GetIsServer() then
		local oldSaveFn=inst.OnSave
		local oldLoadFn=inst.OnLoad
		inst.setAutoTrap=setAutoTrap--升级为智能陷阱函数
		if inst.components.mine then
			inst.components.mine:SetAlignment("trap_immunity")--不会被带有这个标签的生物触发
		end 
		inst.OnSave = function(inst,data)
			if oldSaveFn~=nil then
				oldSaveFn(inst,data)
			end
			if inst:HasTag("autoTrap") then
				data.autovalue=true
			end
		end
		inst.OnLoad = function(inst,data)
			if oldLoadFn~=nil then
				oldLoadFn(inst,data)
			end
			if data~=nil and data.autovalue then
				setAutoTrap(inst)
			end
		end
	end
end
AddPrefabPostInit("trap_bramble",medalHookTrap)--荆棘陷阱
AddPrefabPostInit("trap_teeth",medalHookTrap)--狗牙陷阱

---------------------------------------------触手不主动攻击拥有触手勋章的玩家-------------------------------------------------

--触手搜寻目标函数
local function newRetargetfn(inst)
    return GLOBAL.FindEntity(
        inst,
        TUNING.TENTACLE_ATTACK_DIST,
        function(guy) 
            return guy.prefab ~= inst.prefab
                and guy.entity:IsVisible()
                and not guy.components.health:IsDead()
				and not guy.senior_tentaclemedal
                and (guy.components.combat.target == inst or
                    guy:HasTag("character") or
                    guy:HasTag("monster") or
                    guy:HasTag("animal"))
        end,
        { "_combat", "_health" },
        { "prey" })
end
AddPrefabPostInit("tentacle",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		--修改搜寻目标函数
		if inst.components.combat then
			inst.components.combat:SetRetargetFunction(GLOBAL.GetRandomWithVariance(2, 0.5), newRetargetfn)
		end
	end
end)

--改写小触手搜寻目标函数
local function newSmallRetargetfn(inst)
    return FindEntity(inst,
            TUNING.TENTACLE_PILLAR_ARM_ATTACK_DIST,
            function(guy)
				return not guy.components.health:IsDead() and not guy.senior_tentaclemedal
			end,
            { "_combat", "_health" },-- see entityscript.lua
            { "tentacle_pillar_arm", "tentacle_pillar", "prey", "INLIMBO" },
            { "character", "monster", "animal" }
        )
end
AddPrefabPostInit("tentacle_pillar_arm",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.combat then
			inst.components.combat:SetRetargetFunction(GLOBAL.GetRandomWithVariance(1, .5), newSmallRetargetfn)
		end
	end
end)

---------------------------------------------给传送塔添加自由传送功能-------------------------------------------------
AddPrefabPostInit("townportal", function(inst)
	inst.deliverylist = net_string(inst.GUID, "deliverylist")--传送列表
	inst:AddTag("_writeable")
	inst:AddComponent("talker")--可对话组件
	if TheWorld.ismastersim then
		inst:RemoveTag("_writeable")
		inst:AddComponent("writeable")--可书写组件
		inst:AddComponent("medal_delivery")--自由传送组件
		TheWorld:PushEvent("ms_medal_registertownportal", inst)--注册传送塔
		--修改传送组件消耗函数
		if inst.components.teleporter then
			local oldOnActivate=inst.components.teleporter.onActivate
			inst.components.teleporter.onActivate=function(inst, doer)
				-- if doer:HasTag("has_speed_certificate") then
				if doer.components.inventory and doer.components.inventory:EquipHasTag("speed_certificate") then
					if doer.components.talker ~= nil then
						doer.components.talker:ShutUp()
					end
				elseif oldOnActivate then
					oldOnActivate(inst,doer)
				end
			end
		end
	end
end)

---------------------------------------------蚁狮可以返还等价于打包好的物品价值的石头-------------------------------------------------
AddPrefabPostInit("antlion", function(inst)
	if TheWorld.ismastersim then
		if inst.components.trader and inst.components.trader.onaccept then
			local oldonacceptfn=inst.components.trader.onaccept
			inst.components.trader.onaccept=function(inst,giver,item)
				--如果献祭品有打包组件，则记录奖励数量为献祭品的石头值
				if item.components.unwrappable then
					inst.rewardnum=item.components.tradable.rocktribute
					--如果是包装袋则返还蜡纸
					if item.prefab=="bundle" then
						inst.returnitem="waxpaper"
					end
				end
				oldonacceptfn(inst,giver,item)
			end
		end
		local oldGiveReward=inst.GiveReward
		inst.GiveReward=function(inst)
			--如果有奖励数量，则按照奖励数量进行发奖
			if inst.rewardnum and inst.rewardnum>1 then
				--因为原本就会给一个石头，所以这里需要少发一个
				for i=1,inst.rewardnum-1 do
					LaunchAt(SpawnPrefab(inst.pendingrewarditem), inst, (inst.tributer ~= nil and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
				end
				inst.rewardnum=nil
			end
			--有返还物则生成返还物
			if inst.returnitem then
				LaunchAt(SpawnPrefab(inst.returnitem), inst, (inst.tributer ~= nil and inst.tributer:IsValid()) and inst.tributer or nil, 1, 2, 1)
				inst.returnitem=nil
			end
			oldGiveReward(inst)
		end
	end
end)

---------------------------------------------猪王可以返还蜡纸-------------------------------------------------
AddPrefabPostInit("pigking", function(inst)
	if TheWorld.ismastersim then
		if inst.components.trader and inst.components.trader.onaccept then
			local oldonacceptfn=inst.components.trader.onaccept
			inst.components.trader.onaccept=function(inst,giver,item)
				--如果是包装袋则返还蜡纸
				if item.prefab=="bundle" then
					inst:DoTaskInTime(2 / 3, function(item,giver)
						LaunchAt(SpawnPrefab("waxpaper"), inst, giver, 1, 5, 1)
					end)
				end
				oldonacceptfn(inst,giver,item)
			end
		end
	end
end)

---------------------------------------------月亮孢子可捕捉-------------------------------------------------
AddPrefabPostInit("spore_moon", function(inst)
	if TheWorld.ismastersim then
		if inst.components.workable then
			local oldOnWorkedFn=inst.components.workable.onfinish
			inst.components.workable:SetOnFinishCallback(function(inst, worker)
				local medal_spore_moon=SpawnPrefab("medal_spore_moon")--月亮孢子
				--确保玩家身上还能装月亮孢子，溢出会导致主客机数据不同步报错
				if medal_spore_moon and worker.components.inventory ~= nil and worker.components.inventory:EquipHasTag("moon_bugnet") and worker.components.inventory:CanAcceptCount(medal_spore_moon, 1) > 0 then
					worker.components.inventory:GiveItem(medal_spore_moon, nil, inst:GetPosition())
					worker.SoundEmitter:PlaySound("dontstarve/common/butterfly_trap")
					inst:Remove()
				else
					--玩家不能接受月亮孢子就把月亮孢子移除
					if medal_spore_moon then
						medal_spore_moon:Remove()
					end
					if oldOnWorkedFn then
						oldOnWorkedFn(inst,worker)
					end
				end
			end)
		end
	end
end)

---------------------------------------------修改香蕉树桩、月亮蘑菇树桩产物-------------------------------------------------
--香蕉树桩
AddPrefabPostInit("cave_banana_stump",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.workable then
			local oldOnWorkFn=inst.components.workable.onwork
			inst.components.workable:SetOnWorkCallback(function(inst,worker)
				--玩家处于可移植状态，则移植，否则给木头
				if worker and worker:HasTag("transplantman") then
					inst.components.lootdropper:SpawnLootPrefab("medaldug_fruit_tree_stump")
					inst:Remove()
				elseif oldOnWorkFn then
					oldOnWorkFn(inst,worker)
				end
			end)
		end
	end
end)
--修改蘑菇树桩挖掘函数
local function mushtree_moon_stump_onfinish(inst)
	if inst.components.workable then
		local oldOnFinishFn=inst.components.workable.onfinish
		inst.components.workable:SetOnFinishCallback(function(inst,worker)
			--玩家处于可移植状态，则移植，否则给木头
			if worker and worker:HasTag("transplantman") and math.random()<TUNING_MEDAL.MEDALDUG_FRUIT_TREE_STUMP_CHANCE then
				inst.components.lootdropper:SpawnLootPrefab("medaldug_fruit_tree_stump")
				inst:Remove()
			elseif oldOnFinishFn then
				oldOnFinishFn(inst,worker)
			end
		end)
	end
end
--hook蘑菇树
AddPrefabPostInit("mushtree_moon",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		--蘑菇树桩是先生成蘑菇树再加载成树桩的，所以需要先等它加载完再动手
		inst:DoTaskInTime(0,function(inst)
			--如果本来就是树桩，就直接改造挖掘函数
			if inst:HasTag("stump") then
				mushtree_moon_stump_onfinish(inst)
			else--如果不是树桩，则在它变成树桩的时候改造挖掘函数
				if inst.components.workable then
					local oldOnFinishFn=inst.components.workable.onfinish
					inst.components.workable:SetOnFinishCallback(function(inst,worker)
						oldOnFinishFn(inst,worker)
						mushtree_moon_stump_onfinish(inst)
					end)
				end
			end
		end)
	end
end)

--统一发光浆果方向，治疗强迫症
AddPrefabPostInit("wormlight_plant",function(inst)
	inst.Transform:SetNoFaced()
	if GLOBAL.TheWorld.ismastersim then
		inst.Transform:SetRotation(0)
	end
end)

--修改弹弓射击函数，用于监听射击事件
AddPrefabPostInit("slingshot",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.weapon then
			local old_onprojectilelaunched=inst.components.weapon.onprojectilelaunched
			inst.components.weapon:SetOnProjectileLaunched(function(inst, attacker, target)
				--确保玩家拥有童心~
				if attacker and attacker:HasTag("has_childishness") then
					if inst.components.container ~= nil then
						local ammo_stack = inst.components.container:GetItemInSlot(1)
						local item = inst.components.container:RemoveItem(ammo_stack, false)
						if item ~= nil then
							if item == ammo_stack then
								item:PushEvent("ammounloaded", {slingshot = inst})
							end
							attacker:PushEvent("medal_shoot",{ammo = item})--给玩家推送射击事件，获取子弹信息
							item:Remove()
						end
					end
				elseif old_onprojectilelaunched then
					old_onprojectilelaunched(inst, attacker, target)
				end
			end)
		end
	end
end)

--给耕地加needwater的标签，用于自动浇水
AddPrefabPostInit("nutrients_overlay",function(inst)
	inst:AddTag("needwater")
end)

--修改蜂箱的收获函数，佩戴蜂王勋章采集不出蜜蜂
local function beeboxHarvestHook(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.harvestable then
			local oldonharvestfn = inst.components.harvestable.onharvestfn
			local updatelevel=nil
			if oldonharvestfn then
				updatelevel = MedalGetLocalFn(oldonharvestfn,"updatelevel")
			end
			inst.components.harvestable:SetOnHarvestFn(function(inst, picker, produce)
				if picker and picker.isbeeking then
					if not inst:HasTag("burnt") then
						if inst.components.harvestable then
							inst.components.harvestable:SetGrowTime(nil)
							inst.components.harvestable.pausetime = nil
							inst.components.harvestable:StopGrowing()
						end
						if produce == 6 then
							AwardPlayerAchievement("honey_harvester", picker)
						end
						if updatelevel then
							updatelevel(inst)
						end
					end
				elseif oldonharvestfn then
					oldonharvestfn(inst, picker, produce)
				end
			end)
		end
	end
end

AddPrefabPostInit("beebox",beeboxHarvestHook)
AddPrefabPostInit("beebox_hermit",beeboxHarvestHook)

--hook杀人蜂巢，佩戴蜂王勋章的玩家靠近时不会出杀人蜂
AddPrefabPostInit("wasphive",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.playerprox then
			local oldonnear=inst.components.playerprox.onnear
			inst.components.playerprox:SetOnPlayerNear(function(inst, target)
				if target and not target.isbeeking then
					if oldonnear then
						oldonnear(inst, target)
					end
				end
			end)
		end
	end
end)

--修改沃格斯塔夫工具的名字读取规则，佩戴巧手勋章也能读
local function showRealPrefabName(inst)
	local olddisplaynamefn=inst.displaynamefn
	inst.displaynamefn=function(inst)
		if ThePlayer and ThePlayer:HasTag("has_handy_medal") then
			return STRINGS.NAMES[string.upper(inst.prefab)]
		elseif olddisplaynamefn then
			return olddisplaynamefn(inst)
		end
	end
end

AddPrefabPostInit("wagstaff_tool_1",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_2",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_3",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_4",showRealPrefabName)
AddPrefabPostInit("wagstaff_tool_5",showRealPrefabName)

--给石化树添加可硝化标签
AddPrefabPostInit("rock_petrified_tree",function(inst)
	inst:AddTag("nitrifyable")--可硝化
end)

--不可治疗的角色吃太妃糖可解蜂毒
AddPrefabPostInit("taffy",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.edible then
			local oldoneaten=inst.components.edible.oneaten
			inst.components.edible:SetOnEatenFn(function(inst, eater)
				if eater and eater.components.health and not eater.components.health.canheal then
					if eater.components.debuffable then
						if eater.components.debuffable:HasDebuff("buff_medal_injured") then
							--移除蜂毒BUFF
							eater.components.debuffable:RemoveDebuff("buff_medal_injured")
						end
					end
				end
				if oldoneaten then
					oldoneaten(inst, eater)
				end
			end)
		end
	end
end)

local function SetupLoot(lootdropper)
	local inst = lootdropper.inst

	if inst:HasTag("farm_plant_killjoy") then -- if rotten
		lootdropper:SetLoot(inst.is_oversized and inst.plant_def.loot_oversized_rot or {"immortal_essence"})
	elseif inst.components.pickable ~= nil then
		local plant_stress = inst.components.farmplantstress ~= nil and inst.components.farmplantstress:GetFinalStressState() or FARM_PLANT_STRESS.HIGH
		local product=inst.plant_def.product
		if inst.is_oversized then
			lootdropper:SetLoot({inst.plant_def.product_oversized})
		elseif plant_stress == FARM_PLANT_STRESS.LOW or plant_stress == FARM_PLANT_STRESS.NONE then
			-- lootdropper:SetLoot(math.random < .5 and {product, product, product} or {product, product, product, product})--3.5
			lootdropper:SetLoot({product, product, product})--3
		elseif plant_stress == FARM_PLANT_STRESS.MODERATE then
			lootdropper:SetLoot({product, product})--2
		else -- plant_stress == FARM_PLANT_STRESS.HIGH
			lootdropper:SetLoot({product})--1
		end
	end
end

--不朽果实采摘产出
AddPrefabPostInit("farm_plant_immortal_fruit",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.lootdropper then
			inst.components.lootdropper.lootsetupfn = SetupLoot
		end

		if inst.components.growable then
			local stages = deepcopy(inst.components.growable.stages)
			if stages and #stages>0 then
				for i, v in ipairs(stages) do
					if v and v.name then
						--移除腐烂时间
						if v.name=="full" then
							v.time=function(inst)
								return nil
							end
							local oldfn=v.fn
							--绑定变异产物信息
							v.fn=function(inst, stage, stage_data)
								if oldfn then
									oldfn(inst, stage, stage_data)
								end
								if inst.is_oversized and inst.components.pickable then
									local oldpickfn = inst.components.pickable.onpickedfn
									inst.components.pickable.onpickedfn=function(inst, picker, loot)
										if inst.variation_prefab then
											for _, item in ipairs(loot) do
												if item.prefab and item.prefab=="immortal_fruit_oversized" then
													item.variation_prefab=inst.variation_prefab
												end
											end
										end
										if oldpickfn then
											oldpickfn(inst, picker, loot)
										end
									end
								end
							end
						end
						--移除腐烂状态
						if v.name=="rotten" then
							stages[i]=nil
						end
					end
				end
			end
			inst.components.growable.stages=stages
		end

		if not inst.variation_prefab then
			inst.variation_prefab=weighted_random_choice({medal_fruit_tree_immortal_fruit_scion=1,immortal_fruit=1,immortal_fruit_seed=6})
		end

		--存储变异产物信息
		local oldSaveFn=inst.OnSave
		inst.OnSave=function(inst, data)
			if oldSaveFn then
				oldSaveFn(inst, data)
			end
			data.variation_prefab=inst.variation_prefab
		end
		--读取变异产物信息
		local oldPreLoadFn=inst.OnPreLoad
		inst.OnPreLoad=function(inst,data)
			if oldPreLoadFn then
				oldPreLoadFn(inst,data)
			end
			if data and data.variation_prefab then
				inst.variation_prefab=data.variation_prefab
			end
		end
	end
end)

--多汁浆果采摘推送
AddPrefabPostInit("berrybush_juicy",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.pickable then
			local oldpickfn=inst.components.pickable.onpickedfn
			inst.components.pickable.onpickedfn=function(inst, picker, loot)
				picker:PushEvent("medal_picksomething", { object = inst})
				if oldpickfn then
					oldpickfn(inst, picker, loot)
				end
			end
		end
	end
end)

---------------------------------------------------------------------------------------------------------
-------------------------------------------批量修改预制物------------------------------------------------
---------------------------------------------------------------------------------------------------------
AddPrefabPostInitAny(function(inst)
	--给背包增加不朽功能
	if inst:HasTag("backpack") then
		setCanBeImmortal(inst)
	end
	
	--给海洋鱼加build参数，防止钓鱼时报错
	if inst:HasTag("oceanfish") and not inst:HasTag("swimming") then
		if GLOBAL.TheWorld.ismastersim then
			inst.build = inst.prefab
		end
	end
	
	--给龙虾加build参数，防止钓鱼时报错
	if inst.prefab=="wobster_sheller_land" or inst.prefab=="wobster_moonglass_land" then
		if GLOBAL.TheWorld.ismastersim then
			inst.build = inst.prefab
		end
	end
end)

---------------------------------------------------------------------------------------------------------
----------------------------------------------修改组件---------------------------------------------------
---------------------------------------------------------------------------------------------------------

--修改workable组件中的破坏函数、workedby函数，防止熊大、火药等因素破坏原本不可移植的植物
AddComponentPostInit("workable", function(workable,inst)
	local oldDestroyFn=workable.Destroy
	workable.Destroy=function (self,destroyer)
		if not self.inst:HasTag("cantdestroy") then
			oldDestroyFn(self,destroyer)
		end
	end
	local oldWorkedByFn = workable.WorkedBy
	workable.WorkedBy=function(self,worker,numworks)
		if self.inst:HasTag("cantdestroy") and not worker:HasTag("player") then
			return
		end
		if oldWorkedByFn then
			oldWorkedByFn(self,worker,numworks)
		end
	end
end)

--hook读者组件
AddComponentPostInit("reader", function(self)
	local oldreadfn=self.Read
	self.Read=function(self,book)
		if oldreadfn and oldreadfn(self,book) then
			--推送读书事件,{istemporary是否是临时读者,hasdictionary是否用了新华字典}
			self.inst:PushEvent("readbook",{istemporary=self.inst.medal_t_com and self.inst.medal_t_com.reader,hasdictionary=self.inst.components.inventory and self.inst.components.inventory:EquipHasTag("xinhua_dictionary")})
			return true
		end
		return false
	end
end)



--新增沉默气球、暗影气球制作函数
--[[
AddComponentPostInit("balloonmaker", function(self)
	function self:MakeMedalBalloon(x,y,z,isshadow)
		local balloon = isshadow and SpawnPrefab("shadow_balloon") or SpawnPrefab("medal_balloon")
		if balloon then
			balloon.Transform:SetPosition(x,y,z)
		end
	end
end)
]]



--修改普通鱼竿等待上钩函数，让垂钓勋章钓鱼更迅速
AddComponentPostInit("fishingrod", function(fishingrod,inst)
	local oldWaitForFishFn=fishingrod.WaitForFish
	--上钩函数
	local function DoNibble(inst)
		local fishingrod = inst.components.fishingrod
		if fishingrod and fishingrod.fisherman then
			inst:PushEvent("fishingnibble")
			fishingrod.fisherman:PushEvent("fishingnibble")
			fishingrod.fishtask = nil
		end
	end
	
	fishingrod.WaitForFish=function(self)
		local fishingrodinst = self.inst and self.inst.components.fishingrod
		--是否需要加速钓鱼
		if fishingrodinst and fishingrodinst.fisherman and fishingrodinst.fisherman.medal_fishing_time_mult then
			--如果目标存在且目标有可钓鱼组件
			if self.target and self.target.components.fishable then
				local fishleft = self.target.components.fishable:GetFishPercent()--目标池塘鱼的剩余百分比
				local nibbletime = nil--上钩时间
				if fishleft > 0 then
					local time_mult = fishingrodinst.fisherman.medal_fishing_time_mult or 1--咬钩时间倍率
					--上钩时间=math.max((最小等待时间+(1-剩余百分比)*(最大等待时间-最小等待时间))*咬钩时间倍率,1)
					nibbletime = math.max((self.minwaittime + (1.0 - fishleft)*(self.maxwaittime - self.minwaittime))*time_mult,1)
				end
				self:CancelFishTask()
				if nibbletime then
					self.fishtask = self.inst:DoTaskInTime(nibbletime, DoNibble)
				end
			end
		else
			oldWaitForFishFn(self)
		end
	end
	--hook收集函数，给玩家推送钓鱼的池塘
	local oldCollect=fishingrod.Collect
	fishingrod.Collect=function(self)
		--必须在收集完之前推，不然数据就被清掉了
		if self.caughtfish and self.fisherman and self.target then
			self.fisherman:PushEvent("medal_fishingcollect", {fish = self.caughtfish, pond = self.target} )
		end
		if oldCollect then
			oldCollect(self)
		end
	end
end)


--容器组件
AddComponentPostInit("container", function(self)
	--新增函数用于获取可装备勋章的格子，优先取空，满则取最后一个
	function self:GetSpecificMedalSlotForItem(item)
		if self.usespecificslotsforitems and self.itemtestfn ~= nil then
			for i = 1, self:GetNumSlots() do
				--如果这个勋章可以装备到格子里
				if self:itemtestfn(item, i) then
					--如果i是最后一格了，直接返回i
					if i>=self:GetNumSlots() then
						return i
					end
					--如果格子为空则返回空格子
					if self:GetItemInSlot(i)==nil then
						return i
					end
				--如果这个勋章有勋章组
				elseif item.grouptag then
					local olditem=self:GetItemInSlot(i)
					if olditem~=nil and olditem.grouptag then
						--替换勋章组相同的勋章
						if item.grouptag == olditem.grouptag then
							return i
						end
					end
				end
			end
		end
	end
	--移除容器内所有物品，并按容器格子编号返回数组
	function self:RemoveAllItemsWithSlot()
		local collected_items = {}
		for i = 1, self.numslots do
		    local item = self:RemoveItemBySlot(i)
		    collected_items[i]=item
		end
			
		return collected_items
	end
end)

--修改解锁配方的读取方式，方便隐藏特殊制作栏
AddComponentPostInit("builder", function(self)
	local oldKnowsRecipe=self.KnowsRecipe
	self.KnowsRecipe = function(self,recname)
		local recipe = GetValidRecipe(recname)
		-- 需要特殊标签制作的配方，如果玩家没有标签，直接返回false 
		if recipe~=nil and recipe.builder_tag then
			if not self.inst:HasTag(recipe.builder_tag) then
				return false
			end
		end
		return oldKnowsRecipe(self,recname)
	end
end)
--replica也要Hook
AddClassPostConstruct("components/builder_replica", function(self)
    local oldKnowsRecipe=self.KnowsRecipe
    self.KnowsRecipe = function(self,recipename)
        if self.inst.components.builder ~= nil then
			return self.inst.components.builder:KnowsRecipe(recipename)
		elseif self.classified ~= nil then
			local recipe = GetValidRecipe(recipename)
			if recipe ~= nil and recipe.builder_tag then
				if not self.inst:HasTag(recipe.builder_tag) then
					return false
				end
			end
		end
		return oldKnowsRecipe(self,recipename)
    end
end)

--修改道具持有者函数，防止勋章盒、调料盒在黑暗中关闭
AddComponentPostInit("inventoryitem", function(self)
	local oldIsHeldBy=self.IsHeldBy
	self.IsHeldBy = function(self,guy)
		if self.owner and self.owner.components.container then
			if self.owner.components.inventoryitem and self.owner.components.inventoryitem.owner == guy then
				return true
			end
		end
		return oldIsHeldBy(self,guy)
	end
end)

--玩家是否装备了拥有xx标签的勋章
local function isEquipMedalHasTag(player,tag)
	local hastag=false--是否拥有标签
	if player then
		local medal=player.components.inventory and player.components.inventory:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)--获取玩家身上勋章
		if medal then
			if medal:HasTag(tag) then
				return true
			end
			--如果是融合勋章则从融合勋章里取对应勋章
			if medal:HasTag("multivariate_certificate") and medal.components.container then
				hastag=medal.components.container:HasItemWithTag(tag,1)
			end
		end
	end
	return hastag
end
--Hook库存组件
AddComponentPostInit("inventory", function(self)
	--玩家是否装备了拥有xx标签的装备(装备融合勋章时也顺带检索融合勋章内的勋章)
	local oldEquipHasTag=self.EquipHasTag
	self.EquipHasTag = function(self,tag)
		return oldEquipHasTag(self,tag) or isEquipMedalHasTag(self.inst,tag)
	end
	--获取玩家装备的指定名字的勋章
	function self:EquipMedalWithName(name)
		local medal=self:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
		if medal then
			if medal.prefab == name then
				return medal
			elseif medal:HasTag("multivariate_certificate") then
				if medal.components.container then
					local medal=medal.components.container:FindItem(function(inst) return inst.prefab==name end)
					if medal then
						return medal
					end
				end
			end
		end
	end
	--获取玩家装备的拥有指定勋章组的勋章
	function self:EquipMedalWithgroupTag(tag)
		local medal=self:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
		if medal then
			if medal:HasTag("multivariate_certificate") then
				if medal.components.container then
					local medal=medal.components.container:FindItem(function(inst) return inst.grouptag and inst.grouptag==tag end)
					if medal then
						return medal
					end
				end
			elseif medal.grouptag and medal.grouptag==tag then
				return medal
			end
		end
	end
	--获取玩家装备的拥有指定勋章组的勋章
	function self:EquipMedalWithTag(tag)
		local medal=self:GetEquippedItem(EQUIPSLOTS.MEDAL or EQUIPSLOTS.NECK or EQUIPSLOTS.BODY)
		if medal then
			if medal:HasTag("multivariate_certificate") then
				if medal.components.container then
					local medal=medal.components.container:FindItem(function(inst) return inst:HasTag(tag) end)
					if medal then
						return medal
					end
				end
			elseif medal:HasTag(tag)then
				return medal
			end
		end
	end
	--融合勋章、勋章盒等不自动关闭
	local oldHide=self.Hide
	self.Hide = function(self)
		local medal_loot={}
		for k, v in pairs(self.opencontainers) do
			if k:HasTag("multivariate_certificate") or special_medal_box[k.prefab] or k.prefab=="slingshot" then
				if k.components.container then
					for opener, _ in pairs(k.components.container.openlist) do
					    if k.components.inventoryitem and k.components.inventoryitem:IsHeldBy(opener) then
							table.insert(medal_loot,{medal=k,doer=opener})
						end
					end
				end
			end
		end
		
		if oldHide then
			oldHide(self)
		end
		
		if #medal_loot>0 then
			for k,v in ipairs(medal_loot) do
				if v.doer and v.medal and not v.medal.components.container:IsOpen() then
					v.medal.components.container:Open(v.doer)
				end
			end
		end
	end
	--优先入盒逻辑
	local oldGiveItem=self.GiveItem
	self.GiveItem = function(self, inst, slot, src_pos)
		if inst.components.inventoryitem == nil or not inst:IsValid() then
			print("Warning: Can't give item because it's not an inventory item.")
			return
		end
		
		local eslot = self:IsItemEquipped(inst)
		
		if eslot then
			self:Unequip(eslot)
		end
		
		local new_item = inst ~= self.activeitem
		if new_item then
			for k, v in pairs(self.equipslots) do
				if v == inst then
					new_item = false
					break
				end
			end
		end
		
		if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
			inst.components.inventoryitem:RemoveFromOwner(true)
		end
		
		local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst, src_pos)
		if objectDestroyed then
			return
		end
		
		local medalbox_container = nil--特殊盒子容器
		local boxname=nil--盒子名
		if not slot then--没有目标格子才需要执行优先入盒逻辑
			--根据物品类型选择特殊盒子容器
			if inst:HasTag("slingshotammo") then
				boxname="medal_ammo_box"
			elseif inst:HasTag("spice") then
				boxname="spices_box"
			elseif inst:HasTag("medal") then
				boxname="medal_box"
			end
		end
		--根据盒子名搜索玩家身上以及背包中对应的打开状态的容器
		if boxname then
			local medal_boxs=self:FindItems(function(item)
				return item.prefab==boxname and item.components.container and item.components.container:IsOpen()
			end)
			if #medal_boxs>0 then
				for k,v in ipairs(medal_boxs) do
					medalbox_container=v.components.container
					break
				end
			end
		end
		if medalbox_container and medalbox_container:GiveItem(inst, nil, src_pos) then
			return true
		end
		
		return oldGiveItem and oldGiveItem(self, inst, slot, src_pos)
	end
end)

--修改玩家体温调整函数，使玩家在特定情况下不会过冷过热
AddComponentPostInit("temperature", function(self)
	local oldSetTemperature=self.SetTemperature
	self.SetTemperature = function(self,value)
		local inventory=self.inst.components.inventory
		if inventory and inventory:EquipHasTag("nooverheat") then
			value=math.min(value,64)
		end
		if inventory and inventory:EquipHasTag("nofreezing") then
			value=math.max(value,6)
		end
		oldSetTemperature(self,value)
	end
end)

--修改包装组件的打包函数，如果打包后的包裹里有可以献祭的物品则给包裹赋予同等价值
AddComponentPostInit("unwrappable", function(self)
	local oldWrapItems=self.WrapItems
	self.WrapItems = function(self,items,doer)
		if #items > 0 then
			local gold=0
			local rock=0
			for k,v in ipairs(items) do
				if v.components.tradable then
					local goldvalue=v.components.tradable.goldvalue or 0
					local rocktribute=v.components.tradable.rocktribute or 0
					if goldvalue+rocktribute>0 then
						local count=1
						if v.components.stackable and v.components.stackable.stacksize > count then
							count=v.components.stackable.stacksize
						end
						gold=gold+goldvalue*count
						rock=rock+rocktribute*count
					end
				end
			end
			if gold+rock>0 then
				if self.inst.components.tradable==nil then
					self.inst:AddComponent("tradable")
				end
				--价值继承=clamp(floor(总价值*继承倍率),1,200)
				self.inst.components.tradable.goldvalue=math.clamp(math.floor(gold*TUNING_MEDAL.BUNDLE_VALUE_DISCOUNT), 1, 200)
				self.inst.components.tradable.rocktribute=math.clamp(math.floor(rock*TUNING_MEDAL.BUNDLE_VALUE_DISCOUNT), 1, 200)
			end
		end
		oldWrapItems(self,items,doer)
	end
	--存储价值
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		if savedata then
			if self.inst.components.tradable then
				if self.inst.components.tradable.goldvalue and self.inst.components.tradable.goldvalue>0 then
					savedata.goldvalue = self.inst.components.tradable.goldvalue
				end
				if self.inst.components.tradable.rocktribute and self.inst.components.tradable.rocktribute>0 then
					savedata.rocktribute = self.inst.components.tradable.rocktribute
				end
			end
		end
		return savedata
	end
	--读取价值
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if oldOnLoad then
			oldOnLoad(self,data)
		end
		if data.goldvalue or data.rocktribute then
			if self.inst.components.tradable==nil then
				self.inst:AddComponent("tradable")
			end
			self.inst.components.tradable.goldvalue=data.goldvalue or 0
			self.inst.components.tradable.rocktribute=data.rocktribute or 0
		end
	end
end)

--修改san值计算函数，支持月树花buff
AddComponentPostInit("sanity", function(self)
	local oldDoDelta=self.DoDelta
	self.DoDelta = function(self, delta, overtime)
		if self.yueshubuff then
			if self:IsInsanityMode() then
				if delta<0 then
					delta=delta*TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_ABSORB
				end
			else
				if delta>0 then
					delta=delta*TUNING_MEDAL.MEDAL_BUFF_SANITYREGEN_ABSORB
				end
			end
		end
		if oldDoDelta then
			oldDoDelta(self, delta, overtime)
		end
	end
end)

--修改health计算函数，支持凝血buff
AddComponentPostInit("health", function(self)
	local oldDoDelta=self.DoDelta
	self.DoDelta = function(self, amount, ...)
		if self.ningxuebuff and amount<0 then
			amount=amount*TUNING_MEDAL.MEDAL_BUFF_BLOODSUCKING_ABSORB
		end
		if oldDoDelta then
			oldDoDelta(self, amount, ...)
		end
	end
end)

--饱食度组件新增饱食度下降函数方便箭头显示
AddComponentPostInit("hunger", function(self)
	self.GetBurnrateModifiers = function(self)
		if self.inst.medal_hungerrate then
			local burnrate = self.burnrate*self.burnratemodifiers:Get()
			if self.inst.medal_hungerrate:value() and self.inst.medal_hungerrate:value()~=burnrate then
				self.inst.medal_hungerrate:set(self.burnrate*self.burnratemodifiers:Get())
			end
		end
	end
	local oldDoDelta=self.DoDelta
	self.DoDelta = function(self, amount, ...)
		if self.GetBurnrateModifiers then
			self:GetBurnrateModifiers()
		end
		if oldDoDelta then
			oldDoDelta(self, amount, ...)
		end
	end
end)

--修改海钓竿组件,钓到鱼时推送对应事件
AddComponentPostInit("oceanfishingrod", function(self)
	local oldCatchFish=self.CatchFish
	self.CatchFish = function(self)
		if self.target ~= nil and self.target.components.oceanfishable ~= nil then
			-- print(self.fisher.prefab.."钓到了"..self.target.prefab)
			-- self.fisher:PushEvent("medal_oceanfishingcollect",{fish=self.target})
			self.fisher:PushEvent("medal_fishingcollect", {fish = self.target} )
		end
		if oldCatchFish then
			oldCatchFish(self)
		end
	end
end)

--修改可钓鱼组件，让玩家可钓到遗失塑料袋
AddComponentPostInit("fishable", function(self)
	local oldHookFish=self.HookFish
	self.HookFish = function(self,fisherman)
		if fisherman and fisherman:HasTag("medal_fishingrod") then
			local rod = fisherman.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)--钓竿
			if rod.GetLossPouch then
				local product = rod:GetLossPouch(self.inst,fisherman)
				if product then
					local fish=SpawnPrefab(product)
					if fish ~= nil then
						self.hookedfish[fish] = fish
						self.inst:AddChild(fish)
						fish.entity:Hide()
						fish.persists = false
						if fish.DynamicShadow ~= nil then
							fish.DynamicShadow:Enable(false)
						end
						if fish.Physics ~= nil then
							fish.Physics:SetActive(false)
						end
						if fisherman ~= nil and fish.components.weighable ~= nil then
							fish.components.weighable:SetPlayerAsOwner(fisherman)
						end
						if self.fishleft > 0 then
							self.fishleft = self.fishleft - 1
						end
					end
					return fish
				end
			end
		end
		if oldHookFish then
			return oldHookFish(self,fisherman)
		end
	end
	
	--鱼刷新函数
	local oldRefreshFish=self.RefreshFish
	self.RefreshFish = function(self)
		if self.bait_force then
			--饵力值空了，则清除刷新时间
			if self.bait_force<=0 then
				self.fishrespawntime=nil
			end
			if self.fishrespawntime then
				self.respawntask = self.inst:DoTaskInTime(self.fishrespawntime, function(inst)
					local fishable = inst.components.fishable
					if fishable then
					    fishable.respawntask = nil
					    if fishable.fishleft < fishable.maxfish then
					        fishable.fishleft = fishable.fishleft + 1
					        --消耗饵力值
					        if fishable.bait_force then
					        	fishable.bait_force=math.max(fishable.bait_force-1,0)
					        end
					        if fishable.fishleft < fishable.maxfish then
					        	fishable:RefreshFish()
					        end
					    end
					end
				end)
			end
		elseif oldRefreshFish then
			oldRefreshFish(self)
		end
	end
	
	--存储饵力值
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		if self.bait_force then
			if savedata then
				savedata.bait_force=self.bait_force 
			else
				savedata={bait_force = self.bait_force}
			end
		end
		return savedata
	end
	--加载饵力值
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if data and data.bait_force then
			self.bait_force = data.bait_force
		end
		local fishleft=self.fishleft
		if oldOnLoad then
			oldOnLoad(self,data)
		end
		--擦屁股，防止Load的时候赋空值(无语了，这种东西还要擦屁股)
		if not self.fishleft then self.fishleft=fishleft end
	end
end)

--修改烹饪组件,在锅中收获自己做的料理的时候提升勋章
AddComponentPostInit("stewer", function(self)
	local oldHarvest=self.Harvest
	self.Harvest = function(self,harvester)
		if self.done and harvester ~= nil and self.chef_id == harvester.userid and self.product then
			local cook_medal = harvester.components.inventory and harvester.components.inventory:EquipMedalWithgroupTag("chefMedal")
			if cook_medal and cook_medal.HarvestFoodFn then
				cook_medal.HarvestFoodFn(cook_medal,self.product,harvester,self.inst.prefab)
				-- print(cook_medal.prefab,self.product,harvester.prefab,self.inst.prefab)
			end
		end
		return oldHarvest and oldHarvest(self,harvester) or nil
	end
end)

--修改pickable组件，添加魔法免疫力设定
AddComponentPostInit("pickable", function(self)
	--只有在催熟的时候会被调用
	local oldConsumeCycles=self.ConsumeCycles
	self.ConsumeCycles = function(self,cycles)
		--魔法免疫力+1
		if self.magic_immunity then
			self.magic_immunity=math.min(self.magic_immunity+1,5)
		end
		oldConsumeCycles(self,cycles)
	end
	--只有在催熟的时候会被调用
	local oldFinishGrowing=self.FinishGrowing
	self.FinishGrowing = function(self)
		if self.nomagic then
			return false--禁止催熟
		end
		--免疫力>=5禁止催熟
		if self.magic_immunity and self.magic_immunity>=5 then
			return false
		end
		--符合催熟条件的时候，做个催熟标记，标明本次成熟是催熟的结果
		if not self.useexternaltimer then
			if self.task ~= nil and not (self.canbepicked or self.inst:HasTag("withered")) then
				self.ismagic = true--催熟标记
			end
		else
			if self.regentimerexists(self.inst) and not (self.canbepicked or self.inst:HasTag("withered")) then
				self.ismagic = true--催熟标记
			end
		end
		if oldFinishGrowing then
			return oldFinishGrowing(self)
		end
		return false
	end
	--成熟函数
	local oldRegen=self.Regen
	self.Regen = function(self)
		--是催熟的则取消催熟标记
		if self.ismagic then
			self.ismagic=nil
		--不是催熟的，并且有魔法免疫力，则免疫力-1
		elseif self.magic_immunity then
			self.magic_immunity=math.max(self.magic_immunity-1,0)
		end
		
		if oldRegen then
			oldRegen(self)
		end
	end
	
	--存储函数
	local oldOnSave=self.OnSave
	self.OnSave = function(self)
		local savedata=nil
		if oldOnSave then
			savedata=oldOnSave(self)
		end
		--存储魔法免疫力
		if self.magic_immunity and savedata then
			savedata.magic_immunity=self.magic_immunity
		end
		return savedata
	end
	--加载函数
	local oldOnLoad=self.OnLoad
	self.OnLoad = function(self,data)
		if oldOnLoad then
			oldOnLoad(self,data)
		end
		--读取魔法免疫力
		if data.magic_immunity then
			self.magic_immunity = data.magic_immunity
			self.inst:AddTag("showmedalinfo")
		end
	end
	--继续生长函数(没施肥你生长个毛线)
	local oldResume=self.Resume
	self.Resume = function(self)
		if not self.inst:HasTag("needfertilize") then
			if oldResume then
				oldResume(self)
			end
		end
	end
end)

--修改晒肉架组件,收获时给玩家推送事件(食人花手杖用)
AddComponentPostInit("dryer", function(self)
	local oldHarvest=self.Harvest
	self.Harvest = function(self,harvester)
		if oldHarvest and oldHarvest(self,harvester) then
			harvester:PushEvent("takesomething",{object = self.inst})
			return true
		else
			return false
		end
	end
end)

--修改治疗组件,使用蜂蜜药膏治疗可解蜂毒
AddComponentPostInit("healer", function(self)
	local oldHeal=self.Heal
	self.Heal = function(self,target)
		if self.inst.prefab=="bandage" and target.injured_damage and oldHeal then
			if target.components.debuffable then
				if target.components.debuffable:HasDebuff("buff_medal_injured") then
					--移除蜂毒BUFF
					target.components.debuffable:RemoveDebuff("buff_medal_injured")
				end
			end
			return oldHeal(self,target)
		elseif oldHeal then
			return oldHeal(self,target)
		end
	end
end)

--修改传粉者组件，让育王蜂只能采摘虫木花
AddComponentPostInit("pollinator", function(self)
	--只能采摘虫木花
	local oldCanPollinate=self.CanPollinate
	self.CanPollinate = function(self,flower)
		if self.inst and self.inst:HasTag("medal_bee") then
			return flower ~= nil and flower:HasTag("flower") and flower.prefab=="medal_wormwood_flower" and not table.contains(self.flowers, flower)
		elseif oldCanPollinate then
			return oldCanPollinate(self,flower)
		end
	end
	--生成花(可不能让你生成虫木花啊)
	local oldCreateFlower=self.CreateFlower
	self.CreateFlower = function(self)
		local has_wormwood=false--虫木花标记
		--遍历采花列表
		for k,v in pairs(self.flowers) do
			if v.prefab=="medal_wormwood_flower" then
				has_wormwood=true--采过虫木花
			end
		end
		if has_wormwood then
			if self:HasCollectedEnough() and self.inst:IsOnValidGround() then
				local parentFlower = GetRandomItem(self.flowers)
				--把虫木花换成玫瑰
				local flower = SpawnPrefab(parentFlower.prefab=="medal_wormwood_flower" and "flower_rose" or parentFlower.prefab)
				flower.planted = true
				flower.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
				self.flowers = {}
			end
		elseif oldCreateFlower then
			oldCreateFlower(self)
		end
	end
end)

--hook食物记忆组件，勋章调料的食物也应该只取基础食物来算
local medal_spicedfoods = require("medal_spicedfoods")
AddComponentPostInit("foodmemory", function(self)
	local oldGetBaseFood=self.GetBaseFood
	self.GetBaseFood = function(self,prefab)
		if medal_spicedfoods[prefab] then
			return medal_spicedfoods[prefab].basename
		elseif oldGetBaseFood then
			return oldGetBaseFood(self,prefab)
		end
	end
end)
---------------------------------------------------------------------------------------------------------
----------------------------------------------修改其他文件---------------------------------------------------
---------------------------------------------------------------------------------------------------------

--修改容器界面，勋章盒、调料盒兼容融合模式
AddClassPostConstruct("screens/playerhud", function(self)
    local ContainerWidget = require("widgets/containerwidget")
	local oldOpenContainer=self.OpenContainer
	local oldCloseContainer=self.CloseContainer
	
	--勋章栏容器
	local function OpenMedalWidget(self, container,side)
		local containerwidget = ContainerWidget(self.owner)
		--开了勋章栏的话融合勋章栏放勋章栏的位置，否则默认位置
		local parent = side and self.controls.containerroot_side or (TUNING.ADD_MEDAL_EQUIPSLOTS and TUNING.MEDAL_INV_SWITCH) and self.controls.inv.medal_inv or self.controls.containerroot

		parent:AddChild(containerwidget)
		
		containerwidget:MoveToBack()
		containerwidget:Open(container, self.owner)
		self.controls.containers[container] = containerwidget
	end
	--打开容器
    self.OpenContainer = function(self,container, side)
		if container == nil then
			return
		end
		--融合勋章、勋章盒、调料盒走自己的容器逻辑
		if container:HasTag("multivariate_certificate") or special_medal_box[container.prefab] then
			OpenMedalWidget(self,container,side)
			return
		end
		oldOpenContainer(self,container, side)
    end
	--关闭容器
    self.CloseContainer = function(self,container, side)
		if container == nil then
			return
		end
		--如果是勋章盒、料理盒就把side参数设为false，让盒子正常关闭
		if side and special_medal_box[container.prefab] then
			side=false
		end
		
		oldCloseContainer(self,container, side)
    end
end)

--返回物品详细信息
local function CheckUserHint(inst)
	local classified = ThePlayer and ThePlayer.player_classified
	if classified == nil then
		return ""
	end
	local i = string.find(classified.medal_info,';',1,true)
	if i == nil then
		return ""
	end
	local guid = tonumber(classified.medal_info:sub(1,i-1))
	if guid ~= inst.GUID then
		return ""
	end
	return classified.medal_info:sub(i+1)
end
--显示范围圈
local function showMedalRange(oldtarget,newtarget)
	if oldtarget and oldtarget.medal_show_range then
		oldtarget.medal_show_range:Remove()
		oldtarget.medal_show_range = nil
	end
	if not newtarget then
		return
	end
	if newtarget.medal_show_radius then
		newtarget.medal_show_range=SpawnPrefab("medal_show_range")
		if newtarget:HasTag("INLIMBO") and ThePlayer then
			newtarget.medal_show_range:Attach(ThePlayer)
		else
			newtarget.medal_show_range:Attach(newtarget)
		end
		newtarget.medal_show_range:SetRadius(newtarget.medal_show_radius)
	end
end

if TUNING.SHOW_MEDAL_INFO then
	local save_target--暂存目标
	local last_rangetarget--暂存范围显示目标
	local last_check_time = 0--上一次检查时间
	--hook玩家鼠标停留函数
	AddClassPostConstruct("widgets/hoverer",function(hoverer)
		local oldHide = hoverer.text.Hide
		local oldSetString = hoverer.text.SetString
		hoverer.text.SetString = function(text,str)
			--获取目标
			local target = GLOBAL.TheInput:GetHUDEntityUnderMouse()
			target = (target and target.widget and target.widget.parent ~= nil and target.widget.parent.item) or TheInput:GetWorldEntityUnderMouse() or nil
			--测试模式显示预置物代码
			if TUNING.MEDAL_TEST_SWITCH and target and target.prefab then
				str=str.."\n"..target.prefab
			end
			--获取需显示信息
			if target and target.GUID and (target:HasTag("fishable") or target:HasTag("showmedalinfo") ) then
				local str2 = CheckUserHint(target)
				if str2 and str2 ~= "" then
					str=str..str2
				end
				--目标变了或者时间间隔1秒，则发送rpc
				if target ~= save_target or last_check_time + 1 < GetTime() then
					save_target = target
					last_check_time = GetTime()
					SendModRPCToServer(MOD_RPC.functional_medal.Showinfo, save_target.GUID, save_target)
				end
			end
			--显示范围圈
			if target and target.GUID then
				if last_rangetarget~=target then
					showMedalRange(last_rangetarget,target)
					last_rangetarget = target
				end
			else
				if last_rangetarget then
					showMedalRange(last_rangetarget,nil)
					last_rangetarget = nil
				end
			end
			
			return oldSetString(text,str)
		end
		
		hoverer.text.Hide = function(text)
			if text.shown then
				if last_rangetarget then
					showMedalRange(last_rangetarget,nil)
					last_rangetarget = nil
				end
				oldHide(text)
			end
		end
	end)
end