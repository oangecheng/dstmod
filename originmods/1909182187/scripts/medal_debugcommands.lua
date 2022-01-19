--按列表生成预制物(列表,间隔,对应函数)
local function _spawn_list(list, spacing, fn)
	spacing = spacing or 2
	local num_wide = math.ceil(math.sqrt(#list))

	local pt = ConsoleWorldPosition()
	pt.x = pt.x - num_wide * 0.5 * spacing
	pt.z = pt.z - num_wide * 0.5 * spacing

	for y = 0, num_wide-1 do
		for x = 0, num_wide-1 do
			if list[(y*num_wide + x + 1)] then
				local inst = SpawnPrefab(list[(y*num_wide + x + 1)])
				if inst ~= nil then
					inst.Transform:SetPosition((pt + Vector3(x*spacing, 0, y*spacing)):Get())
					if fn ~= nil then
						fn(inst)
					end
				end
			end
		end
	end
end

--生成所有勋章(isfinal为true则只生成最终形态勋章)
function dm_allmedal(isfinal)
	local items = {"large_multivariate_certificate"}
	if not isfinal then
		table.insert(items, "medium_multivariate_certificate")
		table.insert(items, "multivariate_certificate")
	end
	for k, v in pairs(require("medal_defs/functional_medal_defs").MEDAL_DEFS) do
		if not isfinal or v.isfinal then
			table.insert(items, v.name)
		end
	end
	_spawn_list(items, 1,isfinal and function(inst)
		--有等级则直接满级
		if inst.medal_level and inst.medal_level_max then
			inst.medal_level=inst.medal_level_max
			inst.changemedallevelname:set(inst.medal_level)
		end
		if inst.valkyrie_power then--女武神之力满上
			inst.valkyrie_power=TUNING_MEDAL.VALKYRIE_MEDAL.MAX_POWER
		end
	end)
end

--生成所有果树
function dm_alltrees(spacing)
	local items = {}
	for k, v in pairs(require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS) do
		if v.switch then
			table.insert(items, v.name)
		end
	end
	_spawn_list(items, spacing or 4)
end

--生成所有果树的接穗
function dm_allscions(num,spacing)
	local items = {}
	for k, v in pairs(require("medal_defs/medal_fruit_tree_defs").MEDAL_FRUIT_TREE_DEFS) do
		if v.switch then
			table.insert(items, v.name.."_scion")
		end
	end
	_spawn_list(items, spacing or 1,function(inst)
		if num and inst.components.stackable then
			inst.components.stackable:SetStackSize(math.min(num,inst.components.stackable.maxsize))
		end
	end)
end

--生成所有调料
function dm_allspices(num,spacing)
	local items = {"spice_garlic","spice_sugar","spice_chili","spice_salt"}
	for k, v in pairs(require("medal_defs/medal_spice_defs")) do
		table.insert(items, k)
	end
	_spawn_list(items, spacing or 1,function(inst)
		if num and inst.components.stackable then
			inst.components.stackable:SetStackSize(math.min(num,inst.components.stackable.maxsize))
		end
	end)
end

--生成所有调味料理(料理名,堆叠数量,间隔)
function dm_spicefood(foodname,num,spacing)
	local items = {"spice_garlic","spice_sugar","spice_chili","spice_salt"}
	for k, v in pairs(require("medal_defs/medal_spice_defs")) do
		table.insert(items, k)
	end
	local foods={}
	for i, v in ipairs(items) do
		table.insert(foods,(foodname or "powcake").."_"..v)
	end
	_spawn_list(foods, spacing or 1.5,function(inst)
		if inst.components.stackable then--默认生成最大数量
			inst.components.stackable:SetStackSize(math.min(num or inst.components.stackable.maxsize,inst.components.stackable.maxsize))
		end
	end)
end

--生成所有非原生移植植株
function dm_allplantdugs(num,spacing)
	local items = {}
	for k, v in pairs(require("medal_defs/medal_plantable_defs")) do
		table.insert(items, v.name)
	end
	_spawn_list(items, spacing or 2,function(inst)
		if num and inst.components.stackable then
			inst.components.stackable:SetStackSize(math.min(num,inst.components.stackable.maxsize))
		end
	end)
end

--生成所有勋章书籍
function dm_allbooks(spacing)
	local items = {}
	for k, v in pairs(require("medal_defs/medal_book_defs")) do
		table.insert(items, v.name)
	end
	_spawn_list(items, spacing or 1)
end

--批量生成预置物
function dm_spawnlist(prefab,num,spacing)
	local items={}
	for i=1,num or 1 do
		table.insert(items,prefab)
	end
	_spawn_list(items, spacing or 1)
end
--进入测试模式，显示预置物代码
function dm_test()
	if TUNING.MEDAL_TEST_SWITCH then
		TUNING.MEDAL_TEST_SWITCH=nil
	else
		TUNING.MEDAL_TEST_SWITCH=true
	end
end
--重置拖拽坐标
function dm_resetui()
	ResetMedalUIPos()
end
--生成所有可采摘的巨型作物
function dm_bigplants(spacing)
	local items = {}
	for k, v in pairs(require("prefabs/farm_plant_defs").PLANT_DEFS) do
		if v.product_oversized ~= nil then
			table.insert(items, v.prefab)
		end
	end
	
	_spawn_list(items, spacing or 2.5, 
		function(inst)
			inst.force_oversized=true
			for i = 1, 4 do
				inst:DoTaskInTime((i-1) * 1 + math.random() * 0.5, function()
					inst.components.growable:DoGrowth()
				end)
			end
		end)
end

--生成所有玩具
function dm_alltoys(num,spacing)
	if NUM_TRINKETS and NUM_TRINKETS>0 then
		local items = {"antliontrinket"}
		for k=1, NUM_TRINKETS do
			table.insert(items, "trinket_"..k)
		end
		_spawn_list(items, spacing or 1,function(inst)
			if num and inst.components.stackable then
				inst.components.stackable:SetStackSize(math.min(num,inst.components.stackable.maxsize))
			end
		end)
	end
end

--生成一个藏宝点
function dm_treasure()
	local max_tries=200--最大尝试生成次数
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
				local chest=SpawnPrefab("medal_treasure")
				chest.Transform:SetPosition(x,0,z)
				
				local player = ConsoleCommandPlayer()
				if player and player.player_classified ~= nil then
					player.player_classified.revealmapspot_worldx:set(x)
					player.player_classified.revealmapspot_worldz:set(z)
					player:DoTaskInTime(4*FRAMES, function()
						player.player_classified.revealmapspotevent:push()
						player.player_classified.MapExplorer:RevealArea(x, 0, z)
					end)
				end
				print("尝试了".. (200-max_tries).."次,坐标:"..x..","..z)
				max_tries=-1
			end
		end
	end
	if max_tries==0 then print("生成失败") end
end

--生成所有弹弓子弹(是否只生成勋章特制弹药，堆叠数量，间距)
function dm_allammos(justmedal,num,spacing)
	local items = {
		"slingshotammo_rock",
		"slingshotammo_gold",
		"slingshotammo_marble",
		"slingshotammo_thulecite",
		"slingshotammo_freeze",
		"slingshotammo_slow",
		"slingshotammo_poop",
		"trinket_1",
	}
	if justmedal then
		items = {}
	end
	for k, v in pairs(require("medal_defs/medal_slingshotammo_defs")) do
		if v.switch then
			table.insert(items, k)
		end
	end
	-- num=num or 60--默认生成一组
	_spawn_list(items, spacing or 1,function(inst)
		if inst.components.stackable then
			inst.components.stackable:SetStackSize(math.min(num or inst.components.stackable.maxsize,inst.components.stackable.maxsize))
		end
	end)
end

--生成遗失包裹
function dm_gifts(num,spacing)
	spacing = spacing or 1.5
	local player = ConsoleCommandPlayer()
	local spawnnum=num or 1
	local num_wide = math.ceil(math.sqrt(spawnnum))
	local pt = ConsoleWorldPosition()
	pt.x = pt.x - num_wide * 0.5 * spacing
	pt.z = pt.z - num_wide * 0.5 * spacing
	for y = 0, num_wide-1 do
		for x = 0, num_wide-1 do
			if spawnnum>0 then
				DropBundle(player,player,pt + Vector3(x*spacing, 0, y*spacing))
				spawnnum=spawnnum-1
			end
		end
	end
end

--生成所有种类塑料袋(间距)
function dm_allpouch(spacing)
	local items = {}
	for k, v in pairs(require("medal_defs/medal_bundle_defs")) do
		table.insert(items, k)
	end
	_spawn_list(items, spacing or 1)
end