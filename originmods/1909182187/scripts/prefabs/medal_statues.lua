local prefabs =
{
    "marble",
    "rock_break_fx",
}

--py交易礼物
local function pyGift(inst,pytimes)
	local bundleitems = {}
	--首次交易掉落
	local first_loot = {
		medal_statue_marble_gugugu = {--大帅鸽
			prefab = "messagebottleempty",--空瓶子
			num = 2,
		},
		medal_statue_marble_saltfish = {--咸鱼
			prefab = "oceanfish_small_9_inv",--口水鱼
			num = 1,
		},
		medal_statue_marble_stupidcat = {--猫猫
			prefab = "tillweed",--犁地草
			num = 2,
		},
	}
	--专有掉落
	local gift_loot = {
		--大帅鸽
		medal_statue_marble_gugugu = {
			"glommerfuel",--格罗姆黏液
			"glommerwings",--格罗姆翅膀
			"malbatross_feather",--邪天翁羽毛
		},
		--咸鱼
		medal_statue_marble_saltfish = {
			"spice_salt",--盐粉
			"saltrock",--盐晶
			"oceanfish_small_1_inv",--小孔雀鱼
			"oceanfish_small_2_inv",--针鼻喷墨鱼
			"oceanfish_small_3_inv",--小饵鱼
			"oceanfish_small_4_inv",--三文鱼
		},
		--猫猫
		medal_statue_marble_stupidcat = {
			"medal_fishbones",--鱼骨
			"fishtacos",--鱼肉玉米卷
			"ceviche",--酸橘汁腌鱼
			"barnaclestuffedfishhead",--酿鱼头
			"seafoodgumbo",--海鲜鱼汤
			"fishsticks",--炸鱼排
		},
	}
	--填充掉落
	local nomal_loot = {
		"livinglog",--活木
		"nitre",--硝石
		"marblebean",--大理石豆
		"mosquitosack",--蚊子血囊
		"compostwrap",--肥料包
	}
	
	--首次交易掉落
	if pytimes<=1 then
		local firstItem=SpawnPrefab(first_loot[inst.prefab].prefab)--盐晶
		if firstItem.components.stackable and first_loot[inst.prefab].num>1 then
			firstItem.components.stackable.stacksize = first_loot[inst.prefab].num
		end
		table.insert(bundleitems, firstItem)
	end
	--专有掉落
	table.insert(bundleitems, SpawnPrefab(GetRandomItem(gift_loot[inst.prefab])))
	--填充掉落
	for i=#bundleitems,3 do
		table.insert(bundleitems, SpawnPrefab(GetRandomItem(nomal_loot)))
	end
	
	local bundle = SpawnPrefab("gift")
	bundle.components.unwrappable:WrapItems(bundleitems)
	for i, v in ipairs(bundleitems) do
		v:Remove()
	end
	if inst.components.lootdropper then
		inst.components.lootdropper:FlingItem(bundle)
	end
end

local statues_defs={
	{--缪斯1
		assets={
			Asset("ANIM", "anim/statue_small_type1_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_muse1.xml"),
			Asset("IMAGE", "images/medal_statue_marble_muse1.tex"),
		},
		name="medal_statue_marble_muse1",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type1_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
	},
	{--缪斯2
		assets={
			Asset("ANIM", "anim/statue_small_type2_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_muse2.xml"),
			Asset("IMAGE", "images/medal_statue_marble_muse2.tex"),
		},
		name="medal_statue_marble_muse2",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type2_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
	},
	{--瓷瓶
		assets={
			Asset("ANIM", "anim/statue_small_type3_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_urn.xml"),
			Asset("IMAGE", "images/medal_statue_marble_urn.tex"),
		},
		name="medal_statue_marble_urn",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type3_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
	},
	{--兵卒
		assets={
			Asset("ANIM", "anim/statue_small_type4_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_pawn.xml"),
			Asset("IMAGE", "images/medal_statue_marble_pawn.tex"),
		},
		name="medal_statue_marble_pawn",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_type4_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
	},
	{--丘比特
		assets={
			Asset("ANIM", "anim/statue_small_harp_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_harp.xml"),
			Asset("IMAGE", "images/medal_statue_marble_harp.tex"),
		},
		name="medal_statue_marble_harp",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_harp_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
	},
	{--老麦
		assets={
			Asset("ANIM", "anim/statue_maxwell.zip"),
			Asset("MINIMAP_IMAGE", "statue"),
			Asset("ATLAS", "images/medal_statue_marble_maxwell.xml"),
			Asset("IMAGE", "images/medal_statue_marble_maxwell.tex"),
		},
		name="medal_statue_marble_maxwell",
		bank="statue_maxwell",
		build="statue_maxwell",
		anim="idle_full",
		minimap="statue.png",
		-- symbol="statue_small_harp_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				TheWorld:PushEvent("ms_unlockchesspiece", "formal")
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
				inst.AnimState:PlayAnimation("hit_low")
				inst.AnimState:PushAnimation("idle_low")
			elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
				inst.AnimState:PlayAnimation("hit_med")
				inst.AnimState:PushAnimation("idle_med")
			else
				inst.AnimState:PlayAnimation("hit_full")
				inst.AnimState:PushAnimation("idle_full")
			end
		end,
	},
	{--格罗姆
		assets={
			Asset("ANIM", "anim/glommer_statue.zip"),
			-- Asset("MINIMAP_IMAGE", "statueglommer"),
			Asset("ATLAS", "images/medal_statue_marble_glommer.xml"),
			Asset("IMAGE", "images/medal_statue_marble_glommer.tex"),
		},
		name="medal_statue_marble_glommer",
		bank="glommer_statue",
		build="glommer_statue",
		anim="full",
		minimap="statueglommer.png",
		-- symbol="statue_small_harp_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				-- inst.AnimState:PlayAnimation(workleft < TUNING.ROCKS_MINE * .5 and "med" or "full")
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
	},
	{--咕咕咕
		assets={
			Asset("ANIM", "anim/statue_small_gugugu_build.zip"),
			-- Asset("ANIM", "anim/statue_big_gugugu_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_gugugu.xml"),
			Asset("IMAGE", "images/medal_statue_marble_gugugu.tex"),
		},
		name="medal_statue_marble_gugugu",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_gugugu_build",
		-- symbol="statue_big_gugugu_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
		pytradefn=pyGift,
		-- change_medal_skin=function(inst,shouldchange)--换皮肤函数(inst,需要变换)
		-- 	local state_loot={"statue_small_gugugu_build","statue_big_gugugu_build"}--皮肤列表
		-- 	inst.medal_skin_state=inst.medal_skin_state or 1
		-- 	if shouldchange then--需要换皮
		-- 		inst.medal_skin_state = inst.medal_skin_state % #state_loot + 1
		-- 		local fx = SpawnPrefab("explode_reskin")
		-- 		local x,y,z=inst.Transform:GetWorldPosition()
		-- 		if fx then
		-- 			fx.Transform:SetScale(1.2, 1.2, 1.2)
		-- 			fx.Transform:SetPosition(x,y+0.5,z)
		-- 		end
		-- 	end
		-- 	inst.AnimState:OverrideSymbol("swap_statue", state_loot[inst.medal_skin_state], "swap_statue")
		-- end,
	},
	{--咸鱼
		assets={
			Asset("ANIM", "anim/statue_small_saltfish_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_saltfish.xml"),
			Asset("IMAGE", "images/medal_statue_marble_saltfish.tex"),
		},
		name="medal_statue_marble_saltfish",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_saltfish_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
		pytradefn=pyGift,
	},
	{--沙雕猫
		assets={
			Asset("ANIM", "anim/statue_small_stupidcat_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_stupidcat.xml"),
			Asset("IMAGE", "images/medal_statue_marble_stupidcat.tex"),
		},
		name="medal_statue_marble_stupidcat",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_small_stupidcat_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
		pytradefn=pyGift,
	},
	{--大黑蛋子
		assets={
			Asset("ANIM", "anim/statue_black_egg_build.zip"),
			Asset("ANIM", "anim/statue_small.zip"),
			Asset("MINIMAP_IMAGE", "statue_small"),
			Asset("ATLAS", "images/medal_statue_marble_blackegg.xml"),
			Asset("IMAGE", "images/medal_statue_marble_blackegg.tex"),
		},
		name="medal_statue_marble_blackegg",
		bank="statue_small",
		build="statue_small",
		anim="full",
		minimap="statue_small.png",
		symbol="statue_black_egg_build",
		savestate=true,
		onworkfn=function(inst, worker, workleft)
			if workleft <= 0 then
				local pos = inst:GetPosition()
				SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
				inst.components.lootdropper:DropLoot(pos)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(
					(workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
					(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or
					"full"
				)
			end
		end,
		-- pytradefn=pyGift,
	},
}


local function MakeStatue(def)
	local function onsave(inst,data)
		if inst.medal_skin_state then
			data.medal_skin_state=inst.medal_skin_state
		end
	end

	local function onload(inst,data)
		if data and data.medal_skin_state then
			inst.medal_skin_state=data.medal_skin_state
			if inst.change_medal_skin then
				inst:change_medal_skin()
			end
		end
	end
	
	local function fn()
		local inst = CreateEntity()
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()
		
		MakeObstaclePhysics(inst, 0.66)
		
		inst.entity:AddTag("statue")
		if def.pytradefn then
			inst:AddTag("medal_trade")
		end
		if def.change_medal_skin then
			inst:AddTag("medalskinable")
		end
		
		inst.AnimState:SetBank(def.bank)
		inst.AnimState:SetBuild(def.build)
		if def.symbol then
			inst.AnimState:OverrideSymbol("swap_statue", def.symbol, "swap_statue")
		end
		inst.AnimState:PlayAnimation(def.anim)
		if def.minimap then
			inst.MiniMapEntity:SetIcon(def.minimap)
		end
		
		inst.entity:SetPristine()
		
		if not TheWorld.ismastersim then
		    return inst
		end
		
		inst:AddComponent("lootdropper")
		
		inst:AddComponent("inspectable")
		-- inst.components.inspectable:SetDescription(STRINGS.CHARACTERS.GENERIC.DESCRIBE.MEDAL_STATUE_MARBLE_MUSE1)
		if def.getstatus then inst.components.inspectable.getstatus = def.getstatus end
		
		inst.pyTradeFn=def.pytradefn or nil--py交易函数

		inst.change_medal_skin=def.change_medal_skin--换皮肤函数
		
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.MINE)
		inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
		inst.components.workable:SetOnWorkCallback(def.onworkfn)
		if def.savestate then
			inst.components.workable.savestate = true
			inst.components.workable:SetOnLoadFn(function(inst)
				def.onworkfn(inst, nil, inst.components.workable.workleft)
			end)
		end
		
		MakeHauntableWork(inst)

		-- inst.OnSave=onsave
		-- inst.OnLoad=onload
		
		-- inst:SetPrefabName("medal_statues")--设置预制物名
		
		return inst
	end
	return Prefab(def.name, fn, def.assets, prefabs)
end

local statues = {}
for i, v in ipairs(statues_defs) do
    table.insert(statues, MakeStatue(v))
	table.insert(statues,MakePlacer(v.name.."_placer", v.bank, v.symbol or v.build, v.anim))
end
return unpack(statues)