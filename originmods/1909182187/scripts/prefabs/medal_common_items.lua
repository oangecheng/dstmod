local function MackItem(def)
	local assets =
	{
	    Asset("ANIM", "anim/"..def.build..".zip"),
		Asset("ATLAS", "images/"..def.name..".xml"),
		Asset("ATLAS_BUILD", "images/"..def.name..".xml",256),
	}
	
	local function fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
	
		MakeInventoryPhysics(inst)
	
		inst.AnimState:SetBank(def.bank)
		inst.AnimState:SetBuild(def.build)
		inst.AnimState:PlayAnimation(def.anim or def.name)
		
		if def.taglist then
			for _,v in ipairs(def.taglist) do
				inst:AddTag(v)
			end
		end
		
		if def.floatdata then
			MakeInventoryFloatable(inst,def.floatdata[1],def.floatdata[2],def.floatdata[3])
		else
			MakeInventoryFloatable(inst,"med",0.1,0.65)
		end
	
		inst.entity:SetPristine()
	
		if not TheWorld.ismastersim then
			return inst
		end
		
		if def.maxsize then
			inst:AddComponent("stackable")
			inst.components.stackable.maxsize = def.maxsize
		end
			
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = def.name
		inst.components.inventoryitem.atlasname = "images/"..def.name..".xml"
			
		inst:AddComponent("inspectable")
		
		MakeHauntableLaunchAndSmash(inst)
	
		return inst
	end
	
	return Prefab(def.name, fn, assets)
end
--堆叠数量
local SIZE_L=TUNING.STACK_SIZE_LARGEITEM--10
local SIZE_M=TUNING.STACK_SIZE_MEDITEM--20
local SIZE_S=TUNING.STACK_SIZE_SMALLITEM--40
local SIZE_T=TUNING.STACK_SIZE_TINYITEM--60

local items_loot={
	{--不朽精华
		name="immortal_essence",--预置物名
		bank="immortal_essence",
		build="immortal_essence",
		anim="idle",--动画名，不填默认用name
		maxsize=SIZE_S--堆叠数量
		-- floatdata={"med", 0.1, 0.65},--特殊水面动画参数，不填用默认值
		-- taglist={"cooldownable"},--标签列表
	},
	{--鱼骨
		name="medal_fishbones",
		bank="medal_fishbones",
		build="medal_fishbones",
		maxsize=SIZE_M,
		floatdata={"small", 0.15, 0.8},
	},
	{--方尖碑碎片
		name="sanityrock_fragment",
		bank="sanityrock_fragment",
		build="sanityrock_fragment",
		maxsize=SIZE_S,
	},
	{--血汗钱
		name="toil_money",
		bank="toil_money",
		build="toil_money",
		anim="idle",
		maxsize=SIZE_M,
	},
	{--黑曜石
		name="medal_obsidian",
		bank="medal_obsidian",
		build="medal_obsidian",
		maxsize=SIZE_S,
		taglist={"cooldownable"},--可冷却
	},
	{--蓝曜石
		name="medal_blue_obsidian",
		bank="medal_obsidian",
		build="medal_obsidian",
		anim="medal_blue_obsidian",
		maxsize=SIZE_S,
	},
	{--怪物精华
		name="medal_monster_essence",
		bank="medal_monster_essence",
		build="medal_monster_essence",
		maxsize=SIZE_S,
	},
	{--育王蜂种
		name="medal_bee_larva",
		bank="medal_bee_larva",
		build="medal_bee_larva",
		anim="idle",
		maxsize=SIZE_S,
	},
	{--不朽宝石
		name="immortal_gem",
		bank="immortal_gem",
		build="immortal_gem",
		anim="idle",
	},
	{--时空碎片
		name="medal_time_slider",
		bank="medal_time_slider",
		build="medal_time_slider",
		anim="idle",
		maxsize=SIZE_S,
	},
	{--时空宝石
		name="medal_space_gem",
		bank="medal_space_gem",
		build="medal_space_gem",
		anim="idle",
	},
}

local items = {}
for i, v in ipairs(items_loot) do
    table.insert(items, MackItem(v))
end
return unpack(items)


