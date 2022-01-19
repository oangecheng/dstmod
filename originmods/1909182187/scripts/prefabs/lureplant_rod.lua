local assets =
{
    Asset("ANIM", "anim/lureplant_rod.zip"),
	Asset("ANIM", "anim/swap_lureplant_rod.zip"),
    Asset("ANIM", "anim/floating_items.zip"),
	Asset("ATLAS", "images/lureplant_rod.xml"),
	Asset("ATLAS_BUILD", "images/lureplant_rod.xml",256),
}
--目标预制物列表
local targetList={
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/7.5,prefablist={"sapling","sapling_moon"}},--树枝
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/7.5,prefablist={"grass"}},--草
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/7.5,prefablist={"berrybush","berrybush2","berrybush_juicy"}},--浆果
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"flower_cave","flower_cave_double","flower_cave_triple"}},--荧光果
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"lichen"}},--苔藓
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"marsh_bush"}},--荆棘丛
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"reeds"}},--芦苇
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"cactus","oasis_cactus"}},--仙人掌
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"bullkelp_plant"}},--海带
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"rock_avocado_bush"}},--石果
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/15,prefablist={"meatrack","meatrack_hermit"}},--晒肉架
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/30,prefablist={"beebox","beebox_hermit"}},--蜂蜜
	{num=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES/30,prefablist={"lureplant"}},--食人花叶肉
}
--获取当前目标预置物
local function getTarget(inst)
	if inst and inst.components.finiteuses then
		local uses=inst.components.finiteuses:GetUses()
		local index=TUNING_MEDAL.LUREPLANT_ROD.MAXUSES--索引
		--遍历目标预制物列表，判断当前处于哪个阶段
		for k,v in ipairs(targetList) do
			index=index-v.num
			if uses>index then
				inst.picktarget=v.prefablist--设定当前目标预制物
				break
			end
		end
	end
end

local function onequip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_lureplant_rod", "swap_lureplant_rod")
	--设置饥饿速度为1.5倍
	if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, TUNING_MEDAL.LUREPLANT_ROD.HUNGER_RATE)
		owner:AddTag("lureplant_rod")--特殊快采动作
    end
	
	AddMedalTag(owner,"fastpicker")--快采标签
	-- AddMedalTag(owner,"quagmire_fasthands")--快速收获
	
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	--监听耐久变化
	inst.percentusedchangefn = function(inst,data)
		getTarget(inst)--重新获取目标预制物
	end
	--监听玩家采摘事件
	inst.picksomething = function(self,data)
		if data then
			--采摘的是目标预置物
			if data.object and inst.picktarget and table.contains(inst.picktarget,data.object.prefab) then
				if inst.components.finiteuses then
					inst.components.finiteuses:Use(1*TUNING_MEDAL.LUREPLANT_ROD.CONSUME_MULT)
					SpawnMedalTips(self,1*TUNING_MEDAL.LUREPLANT_ROD.CONSUME_MULT,9)--弹幕提示
				end
			end
		end
	end
	
	inst:ListenForEvent("percentusedchange", inst.percentusedchangefn)
	owner:ListenForEvent("picksomething", inst.picksomething)--采摘
	owner:ListenForEvent("medal_picksomething", inst.picksomething)--采摘(多汁浆果)
	owner:ListenForEvent("harvestsomething", inst.picksomething)--收获
	owner:ListenForEvent("takesomething", inst.picksomething)--拿取(食人花)
end

local function onunequip(inst, owner)
	--取消饥饿加速
	if owner.components.hunger ~= nil then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end
	owner:RemoveTag("lureplant_rod")--快采手杖，用特殊动作
	
	RemoveMedalTag(owner,"fastpicker")--快采标签
	-- RemoveMedalTag(owner,"quagmire_fasthands")--快速收获

    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	inst:RemoveEventCallback("percentusedchange", inst.percentusedchangefn)
	owner:RemoveEventCallback("picksomething", inst.picksomething)
	owner:RemoveEventCallback("medal_picksomething", inst.picksomething)
	owner:RemoveEventCallback("harvestsomething", inst.picksomething)
	owner:RemoveEventCallback("takesomething", inst.picksomething)
end
--返还新勋章
local function returnNewMedal(inst,newmedalname)
	--获取拥有者
	local owner=inst.components.inventoryitem and inst.components.inventoryitem:GetGrandOwner()
	--有拥有者则直接给拥有者
	if owner then
		if owner.components.inventory then
			owner.components.inventory:GiveItem(SpawnPrefab(newmedalname))
		elseif owner.components.container then
			owner.components.container:GiveItem(SpawnPrefab(newmedalname))
		end
	else--否则原地掉落
		if inst.components.lootdropper==nil then
			inst:AddComponent("lootdropper")
		end
		inst.components.lootdropper:SpawnLootPrefab(newmedalname)
	end
	inst:Remove()
end
--耐久用完时执行
local function onfinishedfn(inst)
	returnNewMedal(inst,"harvest_certificate")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("lureplant_rod")
    inst.AnimState:SetBuild("lureplant_rod")
    inst.AnimState:PlayAnimation("lureplant_rod")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
	inst:AddTag("showmedalinfo")--显示详细信息
	--inst:AddTag("quickpickrod")--添加快速采集标签

	local floater_swap_data =
    {
        sym_build = "swap_lureplant_rod",
        sym_name = "swap_lureplant_rod",
        bank = "lureplant_rod",
        anim = "lureplant_rod"
    }
    MakeInventoryFloatable(inst, "med", 0.1, {0.9, 0.4, 0.9}, true, -13, floater_swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
	inst.components.weapon.attackwear=0
    inst.components.weapon:SetDamage(TUNING.CANE_DAMAGE)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "lureplant_rod"
	inst.components.inventoryitem.atlasname = "images/lureplant_rod.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.dapperness = TUNING_MEDAL.LUREPLANT_ROD.SANITY_AURA--san -15/min
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING_MEDAL.LUREPLANT_ROD.MAXUSES)
	inst.components.finiteuses:SetUses(TUNING_MEDAL.LUREPLANT_ROD.MAXUSES)
	inst.components.finiteuses:SetOnFinished(onfinishedfn)
	
	inst:DoTaskInTime(0, function(inst)
		getTarget(inst)--获取目标预置物
	end)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("lureplant_rod", fn, assets)
