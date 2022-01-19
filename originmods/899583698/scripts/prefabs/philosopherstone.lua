local ttrstrs=STRINGS.TTRSTRINGS

local assets=
{
	Asset("ANIM", "anim/philosopherstone.zip"),
	Asset("ATLAS", "images/inventoryimages/philosopherstone.xml"),
}

local prefabs = {
}

local function threshold() return 1010 end--耐久多少能开启创造模式，最大2000
local function fixtimes() return 7200 end--非托托莉角色自动修复耐久从0%到100%需要的秒数

local function findinventory(inst, owner)
    local item = {}
    for k_i, v_i in pairs(owner.components.inventory.itemslots) do
        table.insert(item, v_i)
    end
    for k_e, v_e in pairs(owner.components.inventory.equipslots) do
        table.insert(item, v_e)
    end
    for k_a, v_a in pairs(item) do
        if v_a and v_a.components and v_a.components.container then
            for k_c, v_c in pairs(v_a.components.container.slots) do
                table.insert(item, v_c)
            end
        end
    end
    return item
end

local function dobloom(inst, owner, turnon)
    if not owner or not owner.components.inventory or not owner.components.builder then return end
    if turnon then
        if owner.components.bloomer ~= nil then
            owner.components.bloomer:PushBloom(inst, "shaders/anim.ksh", 1)
        else
            owner.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        end
    else
        if owner.components.bloomer ~= nil then
            owner.components.bloomer:PopBloom(inst)
        else
            owner.AnimState:ClearBloomEffectHandle()
        end
    end
end

local function DeltaUse(inst, value, owner)
    if value < 0 and owner and owner.SoundEmitter and owner.entity then
        owner.SoundEmitter:PlaySound("dontstarve/characters/wendy/abigail/shield/retaliation_fx")
        local fxuse = SpawnPrefab("ghostlyelixir_attack_dripfx")
        fxuse.entity:SetParent(owner.entity)
        fxuse:DoTaskInTime(5, function() if fxuse then fxuse:Remove() end end)
    end
    if owner
    and owner.components.talker
    and owner:HasTag("player")
    and value > 0
    and inst.components.finiteuses.current < inst.components.finiteuses.total then
        if not owner.components.totooriastatus or owner.components.totooriastatus.dengji >= 20 then
            owner.components.talker:Say(ttrstrs[53]..value)
        end
    end
    inst.components.finiteuses:Use(-value)
    if inst.components.finiteuses.current > inst.components.finiteuses.total then
        inst.components.finiteuses:SetUses(inst.components.finiteuses.total)
    end
end

--减少耐久后检查创造模式
local function checkfreebuild(inst, owner)
    if not owner.components.builder then return end
    if inst.components.finiteuses.current < threshold() then
        owner.components.builder.freebuildmode = false
        dobloom(inst, owner, false)
        inst.alreadysaypsstone = false
    end
end

--增加耐久后检查角色是否说过有能量的话
local function checkspeak(inst, owner)
    if not inst.alreadysaypsstone and inst.components.finiteuses.current >= threshold() then
        if owner.components.talker then
            owner:DoTaskInTime(1, function()
                if owner then owner.components.talker:Say(ttrstrs[50]) end
            end)
        end
        if owner.entity then
            local fxcharge = SpawnPrefab("ghostlyelixir_attack_fx")
            fxcharge.entity:SetParent(owner.entity)
            fxcharge:DoTaskInTime(5, function() if fxcharge then fxcharge:Remove() end end)
        end
        inst.alreadysaypsstone = true
    end
end

--右键开关创造模式
local function onuse(inst)
    local owner = inst.components.inventoryitem.owner
    if not owner or not owner.components.builder then return end
    if owner.components.builder.freebuildmode then
        owner.components.builder.freebuildmode = false
        dobloom(inst, owner, false)
    else
        if inst.components.finiteuses.current >= threshold() then
            owner.components.builder.freebuildmode = true
            dobloom(inst, owner, true)
        else
            owner.components.talker:Say(ttrstrs[51])
        end
    end
    --inst.components.useableitem:StopUsingItem()
    return false
end

local function knewrecipe(self, recname)
    local recipe = GetValidRecipe(recname)
    if recipe == nil then
        return false
    end

    local has_tech = true
    local TechTree = require("techtree")
    for i, v in ipairs(TechTree.AVAILABLE_TECH) do
        if recipe.level[v] > (self[string.lower(v).."_bonus"] or 0) then
            has_tech = false
            break
        end
    end
    return (has_tech or table.contains(self.recipes, recname) or self.station_recipes[recname])
    and (recipe.builder_tag == nil or self.inst:HasTag(recipe.builder_tag))
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "philosopherstone", "swap_hat")
    owner.AnimState:Show("HAT")
    if inst.components.finiteuses.current >= threshold() then inst.alreadysaypsstone = true end

    --修复身上物品耐久
    if owner.components.inventory then
        inst.slowfix = inst:DoPeriodicTask(5, function()
            local fixtime = fixtimes()/(inst.components.finiteuses.current/2000 + 1)/5
            local item = findinventory(inst, owner)
            for k, v in pairs(item) do
                if v
                and v.prefab ~= "philosopherstone"
                and v.prefab ~= "vipcard"
                and v.components
                and v.components.inventoryitem then
                    if v.components.finiteuses and v.components.finiteuses.current < v.components.finiteuses.total then
                        v.components.finiteuses:Use(-v.components.finiteuses.total/fixtime)
                        v.components.finiteuses.current = math.min(v.components.finiteuses.current, v.components.finiteuses.total)
                    elseif v.components.armor and v.components.armor.condition < v.components.armor.maxcondition then
                        v.components.armor:SetCondition(v.components.armor.condition + v.components.armor.maxcondition/fixtime)
                    elseif v.components.fueled and v.components.fueled.currentfuel < v.components.fueled.maxfuel then
                        v.components.fueled:DoDelta(v.components.fueled.maxfuel/fixtime)
                    end
                end
            end
        end)
    end

    if owner.components.builder then
        owner.components.builder.oldttrBufferBuild = owner.components.builder.BufferBuild
        owner.components.builder.BufferBuild = function(self, recname, ...)
            local removefn = owner.components.builder.RemoveIngredients
            if self.inst and self.freebuildmode and recname then
                DeltaUse(inst, -threshold(), owner)
                if not knewrecipe(self, recname) then
                    self:UnlockRecipe(recname)
                end
                owner.components.builder.RemoveIngredients = function(ingredients, recname) end
            end
            owner.components.builder.oldttrBufferBuild(self, recname, ...)
            checkfreebuild(inst, owner)
            owner.components.builder.RemoveIngredients = removefn
            return
        end
        owner.components.builder.oldttrDoBuild = owner.components.builder.DoBuild
        owner.components.builder.DoBuild = function(self, recname, pt, rotation, skin)
            local removefn = owner.components.builder.RemoveIngredients
            if self.inst
            and self.freebuildmode
            and recname
            and GetValidRecipe(recname) ~= nil
            and not self:IsBuildBuffered(recname)
            and self:CanBuild(recname) then
                DeltaUse(inst, -threshold(), owner)
                if not knewrecipe(self, recname) then
                    self:UnlockRecipe(recname)
                end
                owner.components.builder.RemoveIngredients = function(ingredients, recname) end
            end
            local yesornot = function(self, recname, pt, rotation, skin)
                return owner.components.builder.oldttrDoBuild(self, recname, pt, rotation, skin)
            end
            owner.components.builder.oldttrDoBuild(self, recname, pt, rotation, skin)
            checkfreebuild(inst, owner)
            owner.components.builder.RemoveIngredients = removefn
            return yesornot
        end

        if TUNING.TTRMODE == false then
            owner.components.builder.ancient_bonus = 4
        end
    end

    local multiplier = 1
    if owner.components.totooriastatus then
        owner.components.totooriastatus.expmod = 2
        multiplier = 2
    end

    inst.ttrkoother = function(owner, data)
        local victim = data.victim
        if victim.components.freezable or victim:HasTag("monster") and victim.components.health then
            DeltaUse(inst, math.ceil(victim.components.health.maxhealth/100)*multiplier, owner)
            checkspeak(inst, owner)
        end
    end
    inst.ttrunlockrecipe =  function(owner,data)
        DeltaUse(inst, 5*multiplier, owner)
        checkspeak(inst, owner)
    end
    inst.ttrattacked = function(owner,data)
        DeltaUse(inst, 1*multiplier, owner)
        checkspeak(inst, owner)
    end
    inst:ListenForEvent("killed", inst.ttrkoother, owner)
    inst:ListenForEvent("unlockrecipe", inst.ttrunlockrecipe, owner)
    inst:ListenForEvent("attacked", inst.ttrattacked, owner)

    if not owner or not owner.components.eater then return end
    owner.components.eater.oldttreatfn = owner.components.eater.oneatfn
    owner.components.eater.oneatfn = function(owner, food)
        if not food or not food.components.edible or food.prefab == "mandrake" then
            return owner.components.eater.oldttreatfn(owner, food)
        end

        local value = 0
        local table = {
            ["plantmeat"] = 20,
            ["plantmeat_cooked"] = 20,
            ["royal_jelly"] = 20,
            ["cookedmandrake"] = 20,
            ["mandrakesoup"] = 20,
            ["tallbirdegg"] = 20,
            ["tallbirdegg_cooked"] = 20,
            ["tallbirdegg_cracked"] = 20,
            ["wormlight"] = 20,

            ["butter"] = 60,
            ["jellybean"] = 10,
            ["deerclops_eyeball"] = 100,
            ["minotaurhorn"] = 200,
        }
        for k,v in pairs(table) do
            if food.prefab == k then
                value = v
            end
        end
        if food and food.components.edible and value == 0 then
            local hunger = math.abs(food.components.edible:GetHunger())
            local sanity = math.abs(food.components.edible:GetSanity())
            local health = math.abs(food.components.edible:GetHealth())
            value = math.ceil((hunger + sanity + health)*.04)
        end

        DeltaUse(inst, value*multiplier, owner)
        checkspeak(inst, owner)
        if owner.components.eater.oldttreatfn then
            return owner.components.eater.oldttreatfn(owner, food)
        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_hat")
    owner.AnimState:Hide("HAT")
    if inst.slowfix then
        inst.slowfix:Cancel()
    end


    if owner.components.totooriastatus then
        owner.components.totooriastatus.expmod = 1
    end
    if owner.components.builder then
        if TUNING.TTRMODE == false then
            owner.components.builder.ancient_bonus = 0
        end
        owner.components.builder.freebuildmode = false
        dobloom(inst, owner, false)
        owner.components.builder.BufferBuild = owner.components.builder.oldttrBufferBuild
        owner.components.builder.DoBuild = owner.components.builder.oldttrDoBuild
    end

    inst:RemoveEventCallback("killed", inst.ttrkoother, owner)
    inst:RemoveEventCallback("unlockrecipe", inst.ttrunlockrecipe, owner)
    inst:RemoveEventCallback("attacked", inst.ttrattacked, owner)
    if owner.components.eater then
        owner.components.eater.oneatfn = owner.components.eater.oldttreatfn
    end
end

local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("philosopherstone")
    inst.AnimState:SetBuild("philosopherstone")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("hat")

    MakeInventoryFloatable(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/philosopherstone.xml"

    inst:AddComponent("tradable")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(2000)
    inst.components.finiteuses:SetUses(0)
    inst.components.finiteuses.OnSave = function()
        return { uses = inst.components.finiteuses.current }
    end

    inst:AddComponent("useableitem")
    inst.components.useableitem:SetOnUseFn(onuse)

    MakeHauntableLaunch(inst)
	
    return inst
end

return Prefab( "common/inventory/philosopherstone", fn, assets, prefabs) 
