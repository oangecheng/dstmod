local assets =
{
    Asset("ANIM", "anim/medal_treasure_map.zip"),
    Asset("ATLAS", "images/medal_treasure_map.xml"),
	Asset("ATLAS_BUILD", "images/medal_treasure_map.xml",256),
}

local treasure_assets =
{
    Asset("ANIM", "anim/medal_treasure.zip"),
	Asset("MINIMAP_IMAGE", "messagebottletreasure_marker"),
}

local prefabs =
{
    "medal_toy_chest",
	"treasurechest",
}

--接穗列表
local scion_loot={}

--获取果树数据
local MEDAL_FRUIT_TREE_DEFS = require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS
if MEDAL_FRUIT_TREE_DEFS then
	for k, v in pairs(MEDAL_FRUIT_TREE_DEFS) do
		if v.switch and not v.nomagic then
			table.insert(scion_loot, v.name.."_scion")
		end
	end
end
--植物列表
local plant_loot={
	mandrake_seeds = 3,--曼德拉种子
	medaldug_fruit_tree_stump = 3,--砧木桩
	medaldug_reeds = 1,--芦苇丛
	medaldug_cactus = 1,--仙人掌
	medaldug_oasis_cactus = 1,--绿洲仙人掌
	medaldug_flower_cave = 1,--单果荧光果丛
	medaldug_flower_cave_double = 1,--双果荧光果丛
	medaldug_flower_cave_triple = 1,--三果荧光果丛
	medaldug_lightflier_flower = 1,--荧光虫花丛
	medaldug_wormlight_plant = 1,--神秘植物
	medaldug_lichen = 1,--洞穴苔藓
}
--稀有道具列表
local good_loot={
	armor_medal_obsidian = 10,--黑曜甲
	armor_blue_crystal = 10,--蓝曜甲
	armorruins = 10,--铥矿甲
	ruinshat = 10,--铥矿帽
	immortal_book = 10,--不朽之谜
	monster_book = 8,--怪物图鉴
	unsolved_book = 12,--未解之谜
	medal_moonglass_potion = 9,--月光药水
	book_gardening = 1,--应用园艺学
}
--其他填充物列表
local normal_loot={
	"thulecite",--铥矿
	"thulecite_pieces",--铥矿碎片
	"fossil_piece",--化石碎片
	"medal_obsidian",--黑曜石
	"medal_blue_obsidian",--蓝曜石
	"glommerfuel",--格罗姆粘液
	"goldnugget",--金块
	"nitre",--硝石
	"boneshard",--骨片
}

local function onfinishcallback(inst, worker)
	local x,y,z=inst.Transform:GetWorldPosition()
	--如果玩家没装备童心、童真勋章
	-- if worker and not worker:HasTag("has_childishness") and math.random()<TUNING_MEDAL.MEDAL_TOY_CHEST_CHANCE then
	if inst.ischild then
		local chest=SpawnPrefab("medal_toy_chest")
		chest.Transform:SetPosition(x,y,z)
	else
		local chest=SpawnPrefab("treasurechest")
		chest.Transform:SetPosition(x,y,z)
		local treasureitems={}
		local randnum=math.random()--神秘宝藏随机值
		--神秘宝藏
		if randnum<TUNING_MEDAL.SURPRISE_TREASURE_CHANCE then
			treasureitems={
				"redgem",--红宝石
				"bluegem",--蓝宝石
				"purplegem",--紫宝石
				"orangegem",--橙宝石
				"yellowgem",--黄宝石
				"greengem",--绿宝石
				"opalpreciousgem",--彩虹宝石
			}
			if randnum<TUNING_MEDAL.SURPRISE_TREASURE_BETTER_CHANCE then
				table.insert(treasureitems, "immortal_gem")--不朽宝石
			end
			if randnum<TUNING_MEDAL.SURPRISE_TREASURE_BEST_CHANCE then
				table.insert(treasureitems, "medal_space_gem")--时空宝石
			end
		else--普通宝藏
			--加入随机植物
			table.insert(treasureitems,weighted_random_choice(plant_loot))
			--加入随机稀有道具
			table.insert(treasureitems,weighted_random_choice(good_loot))
			--加入随机接穗
			table.insert(treasureitems, GetRandomItem(scion_loot))
			--加入2个随机玩具
			for i=1,2 do
				table.insert(treasureitems, PickRandomTrinket())
			end
			--加入2~4个时空碎片
			for i=1,math.random(2,4) do
				table.insert(treasureitems, "medal_time_slider")
			end
			
			--[[
			--加入1-2个随机接穗
			for i = 1, math.random(1, 2) do
				table.insert(treasureitems, GetRandomItem(scion_loot))
			end
			--加入2-3个随机玩具
			for i=#treasureitems,5 do
				-- table.insert(treasureitems, "trinket_"..math.random(HALLOWEDNIGHTS_TINKET_START-1))
				table.insert(treasureitems, PickRandomTrinket())
			end
			]]
			--加入其它填充物
			for i = 1, math.random(3) do
				local item=GetRandomItem(normal_loot)
				for i = 1, math.random(3) do
					table.insert(treasureitems, item)
				end
			end
		end
		
		if chest.components.container then
			for i, v in ipairs(treasureitems) do
				local treasureitem=SpawnPrefab(v)
				if treasureitem then 
					chest.components.container:GiveItem(treasureitem)
				end
			end
		end
	end
	
	SpawnPrefab("sand_puff_large_front").Transform:SetPosition(x,y,z)
	inst:Remove()
end

local function ondig(inst, worker, workleft)
	if worker and workleft>0 then
		local x,y,z=worker.Transform:GetWorldPosition()
		local root=SpawnPrefab("deciduous_root")
		if root then
			root.Transform:SetPosition(x,y,z)
		end
	end
end
--添加萤火虫
local function addFireflies(inst)
	inst.ischild=true
	inst.Light:Enable(true)
    inst.AnimState:PlayAnimation("idle_1",true)
end

local function onsavefn(inst,data)
	if inst.ischild then
		data.ischild=true
	end
end

local function onloadfn(inst,data)
	if data~=nil and data.ischild then
		addFireflies(inst)
	end
end

local function treasure_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

	inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(180/255, 195/255, 150/255)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)
	
	inst.MiniMapEntity:SetIcon("messagebottletreasure_marker.png")
	inst.MiniMapEntity:SetPriority(6)
	
    inst.AnimState:SetBank("medal_treasure")
    inst.AnimState:SetBuild("medal_treasure")
    inst.AnimState:PlayAnimation("idle_3",true)
	
	inst:AddTag("medal_treasure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.addFireflies=addFireflies

    inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(10)--需要挖十下
    inst.components.workable:SetOnFinishCallback(onfinishcallback)
    inst.components.workable:SetOnWorkCallback(ondig)

	inst.OnSave = onsavefn
	inst.OnLoad = onloadfn

    return inst
end

--生成宝藏
local function spawnTreasure(inst, doer)
	local max_tries=100--最大尝试生成次数
	local radius=50--两个宝藏的最小距离
	local w, h = TheWorld.Map:GetSize()
	w = (w - w/2) * TILE_SCALE
	h = (h - h/2) * TILE_SCALE
	while (max_tries > 0) do
		max_tries = max_tries - 1
		local x, z = (math.random()*2-1)*w, (math.random()*2-1)*h
		if TheWorld.Map:IsPassableAtPoint(x, 0, z)	then
			local isnear=false--是否在其他宝藏附近
			if #(TheSim:FindEntities(x, 0, z, radius, {"medal_treasure"})) >0 then
				isnear=true
			end
			
			if not isnear then
				local treasure=SpawnPrefab("medal_treasure")
				treasure.Transform:SetPosition(x,0,z)
				if doer.player_classified ~= nil then
					doer.player_classified.revealmapspot_worldx:set(x)
					doer.player_classified.revealmapspot_worldz:set(z)
					doer:DoTaskInTime(4*FRAMES, function()
						doer.player_classified.revealmapspotevent:push()
						doer.player_classified.MapExplorer:RevealArea(x, 0, z)
					end)
				end
				return true
				-- max_tries=-1
			end
		end
	end
	return false
end

--获取藏宝点(藏宝图,探测仪)
local function getTreasurePoint(inst,resonator)
	if inst.treasure_data then
		return inst.treasure_data--有坐标点信息了就直接return
	end
	
	local max_tries=100--最大尝试生成次数
	local radius=50--两个宝藏的最小距离
	local w, h = TheWorld.Map:GetSize()
	w = (w - w/2) * TILE_SCALE
	h = (h - h/2) * TILE_SCALE
	local ix,iy,iz=inst.Transform:GetWorldPosition()--获取探测仪坐标
	local prior_radius=200--宝藏优先生成范围(包含正负数，所以实际范围要*2)
	local prior_tries=4--每多少次尝试在范围内生成一个坐标点
	while (max_tries > 0) do
		local x, z
		max_tries = max_tries - 1
		if max_tries%prior_tries==0 then--每隔prior_tries次就尝试一次在范围内生成
			x, z = (math.random()*2-1)*prior_radius+ix, (math.random()*2-1)*prior_radius+iz
		else
			x, z = (math.random()*2-1)*w, (math.random()*2-1)*h
		end
		x, z = x-x%0.01, z-z%0.01--保留两位小数
		-- if TheWorld.Map:IsPassableAtPoint(x, 0, z) then
		if TheWorld.Map:IsAboveGroundAtPoint(x, 0, z, false) then
			local isnear=false--是否在其他宝藏附近
			local canspawn=true--是否可生成藏宝点
			--离其他宝藏太近不能生成藏宝点
			if #(TheSim:FindEntities(x, 0, z, radius, {"medal_treasure"})) >0 then
				canspawn=false
				-- print("离其他的太近了")
			end
			--坐标点必需可以部署探测仪
			if resonator and canspawn then
				if not TheWorld.Map:CanDeployAtPoint(Vector3(x, 0, z), resonator) then
					canspawn=false
					-- print("这里不能部署")
				end
			end
			
			if canspawn then
				inst.treasure_data={ worldid = TheShard:GetShardId(), x = x, z = z}--记录藏宝点信息
				-- print(x,z,max_tries)
				return inst.treasure_data
			end
		end
	end
end

local function onsavefn(inst,data)
	--保存藏宝点信息
	if inst.treasure_data then
		data.treasure_data=shallowcopy(inst.treasure_data)
	end
end

local function onloadfn(inst,data)
	--读取藏宝点信息
	if data and data.treasure_data then
		inst.treasure_data=shallowcopy(data.treasure_data)
	end
end

--定义藏宝图
local function map_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("medal_treasure_map")
    inst.AnimState:SetBuild("medal_treasure_map")
    inst.AnimState:PlayAnimation("medal_treasure_map")
	
	MakeInventoryFloatable(inst,"med",nil, 0.75)
    inst.entity:SetPristine()
	
	-- inst:AddTag("medal_treasure_map")--可阅读
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "medal_treasure_map"
    inst.components.inventoryitem.atlasname = "images/medal_treasure_map.xml"
	
	inst.spawnTreasure=spawnTreasure
	inst.getTreasurePoint=getTreasurePoint
	
	inst.OnSave = onsavefn
	inst.OnLoad = onloadfn

    return inst
end

--定义藏宝图碎片(代码,预制物列表,开包裹时里面的物品是否抛掷出来)
local function MakeMapScraps(name)
	local scraps_assets={
		Asset("ANIM", "anim/medal_treasure_map_scraps.zip"),
		Asset("ATLAS", "images/"..name..".xml"),
		Asset("ATLAS_BUILD", "images/"..name..".xml",256),
	}
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("medal_treasure_map_scraps")
		inst.AnimState:SetBuild("medal_treasure_map_scraps")
		inst.AnimState:PlayAnimation(name)
		
		MakeInventoryFloatable(inst,"med",nil, 0.75)
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("inspectable")
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = name
		inst.components.inventoryitem.atlasname = "images/"..name..".xml"
		
		return inst
	end
	
	return Prefab(name, fn, scraps_assets)
end

return Prefab("medal_treasure_map", map_fn, assets),
	Prefab("medal_treasure", treasure_fn, treasure_assets, prefabs),
	MakeMapScraps("medal_treasure_map_scraps1"),
	MakeMapScraps("medal_treasure_map_scraps2"),
	MakeMapScraps("medal_treasure_map_scraps3")


