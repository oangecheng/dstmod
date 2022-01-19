require "prefabutil"

local function onopen(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end

local function onclose(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end

local function ondropped(inst)
    if inst.components.container ~= nil then
        inst.components.container:Close()
    end
end

--定义盒子
local function MakeBox(name,box_def)
	local assets =
	{
	    Asset("ANIM", "anim/"..box_def.build..".zip"),
		Asset("ATLAS", "images/"..box_def.atlas..".xml"),
		Asset("ATLAS_BUILD", "images/"..box_def.atlas..".xml",256),
	}
	
	local function fn()
	    local inst = CreateEntity()
	
	    inst.entity:AddTransform()
	    inst.entity:AddAnimState()
	    inst.entity:AddSoundEmitter()
	    inst.entity:AddNetwork()
		
		MakeInventoryPhysics(inst)
	    
	    inst.AnimState:SetBank(box_def.bank)
	    inst.AnimState:SetBuild(box_def.build)
	    inst.AnimState:PlayAnimation(box_def.anim)
		
		MakeInventoryFloatable(inst, "med", nil, 0.75)
		
		if box_def.taglist then
			for _, tag in pairs(box_def.taglist) do
				inst:AddTag(tag)
			end
		end
		
	    inst.entity:SetPristine()
	
	    if not TheWorld.ismastersim then
	        return inst
	    end
	
	    inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.imagename = box_def.image
		inst.components.inventoryitem.atlasname = "images/"..box_def.atlas..".xml"
		
		inst.components.inventoryitem:SetOnDroppedFn(ondropped)
		
	    inst:AddComponent("container")
	    inst.components.container:WidgetSetup(box_def.weight)
	    inst.components.container.onopenfn = box_def.onopenfn or onopen
	    inst.components.container.onclosefn = box_def.onclosefn or onclose
	
	    return inst
	end
	
	return Prefab(name, fn, assets)
end

local box_defs={}--盒子列表
--勋章盒
box_defs.medal_box={
	bank="medal_box",
	build="medal_box",
	anim="idle_1",
	image="medal_box1",
	atlas="medal_box",
	taglist={"medal_box"},
	weight="medal_box",
	onopenfn=function(inst)
		inst.AnimState:PlayAnimation("idle_3")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName("medal_box2")
		end
	end,
	onclosefn=function(inst)
		inst.AnimState:PlayAnimation("idle_1")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
		if inst.components.inventoryitem then
			inst.components.inventoryitem:ChangeImageName("medal_box1")
		end
	end,
}
--调料盒
box_defs.spices_box={
	bank="spices_box",
	build="spices_box",
	anim="spices_box",
	image="spices_box",
	atlas="spices_box",
	weight="spices_box",
}
--弹药盒
box_defs.medal_ammo_box={
	bank="medal_ammo_box",
	build="medal_ammo_box",
	anim="medal_ammo_box",
	image="medal_ammo_box",
	atlas="medal_ammo_box",
	weight="medal_ammo_box",
}

local boxs={}
for k, v in pairs(box_defs) do
    table.insert(boxs, MakeBox(k,v))
end
return unpack(boxs)

