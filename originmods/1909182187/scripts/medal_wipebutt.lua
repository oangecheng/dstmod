------------------------------------------------------------------------------------------------------
-------------------------------------------修改Mod料理相关函数-----------------------------------------------
------------------------------------------------------------------------------------------------------
--修改是否是Mod食谱函数(只是加了个锅凭啥算Mod料理！)
local oldIsModCookingProductfn = GLOBAL.IsModCookingProduct
GLOBAL.IsModCookingProduct=function(cooker, name)
	if cooker == "medal_cookpot" then return false end
	if oldIsModCookingProductfn then
		return oldIsModCookingProductfn(cooker,name)
	end
    return false
end
------------------------------------------------------------------------------------------------------
-------------------------------------------补充调味料理-----------------------------------------------
------------------------------------------------------------------------------------------------------

local cooking = require("cooking")

require "medal_spicedfoods"
--Mod加载完后给所有食谱添加一遍新调料的料理，以下代码参考了风铃大佬的小穹，风铃大佬牛逼！
local oldRegisterPrefabs = GLOBAL.ModManager.RegisterPrefabs 

GLOBAL.ModManager.RegisterPrefabs = function(self,...)
    --这个时候 PrefanFiles文件还没有被加载
	--把所有的扩展制作栏层级变低，方便双排排序
	if TUNING.MEDAL_NEW_CRAFTTABS_SWITCH then
		for k, v in pairs(CUSTOM_RECIPETABS) do
			if v.sort>0 then
				v.sort=math.min(v.sort-1000,-1)
			end
		end
	end
	
	--所有的菜谱都过一遍，把需要添加新料理的食谱都记下来
    for k,v in pairs(cooking.recipes) do
        if k and v then
			MedalGenerateSpicedFoods(v)
			--添加菜谱到勋章远古锅里
			for a,b in pairs(v) do
				if not b.spice then--要把调味料理排除掉
					local newrecipe=shallowcopy(b)--浅拷贝一份料理数据
					newrecipe.no_cookbook=true--不应该显示到食谱书里去
					AddCookerRecipe("medal_cookpot",newrecipe)
				end
			end
        end
    end
	--添加新的调味料理食谱
    for k,v in pairs(MedalGetNewRecipes()) do
        AddCookerRecipe("portablespicer",v)
    end
    oldRegisterPrefabs(self,...)
end

------------------------------------------------------------------------------------------------------
---------------------------------------修复调味锅的贴图显示-------------------------------------------
------------------------------------------------------------------------------------------------------
local medal_spices=require("medal_defs/medal_spice_defs")
--展示料理
local function newShowProduct(inst)
    if not inst:HasTag("burnt") then
        local product = inst.components.stewer.product
        local recipe = cooking.GetRecipe(inst.prefab, product)
        if recipe ~= nil then
			product = recipe.basename or product
            if recipe.spice ~= nil then
                inst.AnimState:OverrideSymbol("swap_plate", "plate_food", "plate")
                --如果是新调料则显示新调料的贴图
				if medal_spices[string.lower(recipe.spice)] then
					inst.AnimState:OverrideSymbol("swap_garnish", "medal_spices", string.lower(recipe.spice))
				else
					inst.AnimState:OverrideSymbol("swap_garnish", "spices", string.lower(recipe.spice))
				end
            else
                inst.AnimState:ClearOverrideSymbol("swap_plate")
                inst.AnimState:ClearOverrideSymbol("swap_garnish")
            end
        else
            inst.AnimState:ClearOverrideSymbol("swap_plate")
            inst.AnimState:ClearOverrideSymbol("swap_garnish")
        end
		
		local symbol_override_build = (recipe ~= nil and recipe.overridebuild) or "cook_pot_food"
		--如果是游戏原生的基础料理则用基础料理的贴图显示方法,这里是因为新调味料理算Mod料理,但是实际上贴图还是需要用到原生料理贴图
		if IsNativeCookingProduct(product) then
			inst.AnimState:OverrideSymbol("swap_cooked", symbol_override_build, product)
		elseif IsModCookingProduct(inst.prefab, inst.components.stewer.product) then
			inst.AnimState:OverrideSymbol("swap_cooked", product, product)
        else
            inst.AnimState:OverrideSymbol("swap_cooked", symbol_override_build, product)
        end
    end
end

local function donecookfn(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("cooking_pst")
        inst.AnimState:PushAnimation("idle_full", false)
        newShowProduct(inst)
        inst.SoundEmitter:KillSound("snd")
        inst.SoundEmitter:PlaySound("dontstarve/common/together/portable/spicer/cooking_pst")
    end
end

local function continuedonefn(inst)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("idle_full")
        newShowProduct(inst)
    end
end
--调整调味锅的贴图显示，防止出现空贴图的情况
AddPrefabPostInit("portablespicer",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.stewer then
			inst.components.stewer.oncontinuedone = continuedonefn
			inst.components.stewer.ondonecooking = donecookfn
		end
	end
end)

------------------------------------------------------------------------------------------------------
---------------------------------------------鱼人面具-------------------------------------------------
------------------------------------------------------------------------------------------------------

--鱼人面具装备函数
local function merm_equip(inst,owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("equipskinneditem", inst:GetSkinName())
		owner.AnimState:OverrideItemSkinSymbol("swap_hat", skin_build, "swap_hat", inst.GUID, "hat_merm")
	else
		owner.AnimState:OverrideSymbol("swap_hat", "hat_merm", "swap_hat")
	end

	owner.AnimState:Show("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")

	owner.AnimState:Show("HEAD")
	owner.AnimState:Hide("HEAD_HAT")

	if inst.components.fueled ~= nil then
		inst.components.fueled:StartConsuming()
	end
	---------分割线，上面为通用函数，下面才是鱼人面具功能函数-------
	if owner.components.leader then
		owner.components.leader:RemoveFollowersByTag("pig")
	end

	--伪装鱼人标签，如果有就不能收买鱼人守卫
	owner:AddTag("mermdisguise")
	AddMedalTag(owner,"merm")--鱼人
	
	if owner:HasTag("monster") then
		inst.wasmonster = true
		owner:RemoveTag("monster")
	end
end

--鱼人面具卸载函数
local function merm_unequip(inst,owner)
	local skin_build = inst:GetSkinBuild()
	if skin_build ~= nil then
		owner:PushEvent("unequipskinneditem", inst:GetSkinName())
	end

	owner.AnimState:ClearOverrideSymbol("swap_hat")
	owner.AnimState:Hide("HAT")
	owner.AnimState:Hide("HAIR_HAT")
	owner.AnimState:Show("HAIR_NOHAT")
	owner.AnimState:Show("HAIR")

	if owner:HasTag("player") then
		owner.AnimState:Show("HEAD")
		owner.AnimState:Hide("HEAD_HAT")
	end

	if inst.components.fueled ~= nil then
		inst.components.fueled:StopConsuming()
	end
	---------分割线，上面为通用函数，下面才是鱼人面具功能函数-------
	if inst.wasmonster then
		owner:AddTag("monster")
		inst.wasmonster=false
	end
	owner:RemoveTag("mermdisguise")
	RemoveMedalTag(owner,"merm")--鱼人
end

--修改鱼人面具的穿脱函数
AddPrefabPostInit("mermhat",function(inst)
	if GLOBAL.TheWorld.ismastersim then
		if inst.components.equippable then
			inst.components.equippable:SetOnEquip(merm_equip)
			inst.components.equippable:SetOnUnequip(merm_unequip)
		end
	end
end)

------------------------------------------------------------------------------------------------------
---------------------------------------------弹弓弹药-------------------------------------------------
------------------------------------------------------------------------------------------------------
--有问题的弹药列表(不想遍历所有预置物了，干脆列一下得了)
local ammo_list={
	"slingshotammo_rock",--鹅卵石
	"slingshotammo_gold",--黄金弹药
	"slingshotammo_marble",--大理石弹
	"slingshotammo_thulecite",--诅咒弹药
	"slingshotammo_freeze",--冰冻弹药
	"slingshotammo_slow",--减速弹药
	"slingshotammo_poop",--便便弹
	"trinket_1",--融化的大理石
}
--弹弓的临时仇恨系统，目标在打其他玩家或生物时，使用弹弓攻击不会吸引走目标的仇恨
local function no_aggro(attacker, target)
	if target and attacker then
		local targets_target = target.components.combat ~= nil and target.components.combat.target or nil
		return targets_target ~= nil and targets_target:IsValid() and targets_target ~= attacker and attacker:IsValid()
				and (GetTime() - target.components.combat.lastwasattackedbytargettime) < 4
				and (targets_target.components.health ~= nil and not targets_target.components.health:IsDead())
	end
end
--修正弹药的预打击函数，防止吸引仇恨
for k,v in ipairs(ammo_list) do
	AddPrefabPostInit(v.."_proj",function(inst)
		if GLOBAL.TheWorld.ismastersim then
			if inst.components.projectile then
				inst.components.projectile.onprehit=function(inst, attacker, target)
					if target.components.combat then
						target.components.combat.temp_disable_aggro = no_aggro(attacker, target)
					end
				end
			end
		end
	end)
end