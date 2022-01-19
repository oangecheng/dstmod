local _G=GLOBAL


local open_beta=_G.aipGetModConfig("open_beta")=="open"


local dev_mode=_G.aipGetModConfig("dev_mode")=="enabled"


local additional_food=_G.aipGetModConfig("additional_food")=="open"


local additional_chesspieces=_G.aipGetModConfig("additional_chesspieces")=="open"



function ShadowFollowerPrefabPostInit(inst)
if not _G.TheWorld.ismastersim then
return
end

if not inst.components.shadow_follower then
inst:AddComponent("shadow_follower")
end
end

AddPrefabPostInit("dragonfly",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("deerclops",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("bearger",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("moose",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("beequeen",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("klaus",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("klaus_sack",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("antlion",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("toadstool",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("toadstool_dark",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("crabking",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("hermithouse",function(inst) ShadowFollowerPrefabPostInit(inst) end)
AddPrefabPostInit("malbatross",function(inst) ShadowFollowerPrefabPostInit(inst) end)


local birds={ "crow","robin","robin_winter","canary","quagmire_pigeon","puffin" }
if additional_chesspieces then
for i,name in ipairs(birds) do
AddPrefabPostInit(name,function(inst)

if inst.components.periodicspawner~=nil and inst.components.periodicspawner.randtime~=nil then

inst.components.periodicspawner.randtime=inst.components.periodicspawner.randtime*0.95

local originPrefab=inst.components.periodicspawner.prefab


inst.components.periodicspawner.prefab=function(inst)
local prefab=originPrefab
if type(originPrefab)=="function" then
prefab=originPrefab(inst)
end

if prefab=="seeds" and math.random() <=(dev_mode and 9 or .02) then
return "aip_leaf_note"
end

return prefab
end
end
end)
end
end



function dropLeafNote(inst)
if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil and additional_chesspieces then
inst.components.lootdropper:AddChanceLoot("aip_leaf_note",dev_mode and 1 or 0.1)
end
end

AddPrefabPostInit("leif",dropLeafNote)
AddPrefabPostInit("leif_sparse",dropLeafNote)



function createFootPrint(inst)
inst:ListenForEvent("death",function()

if math.random() <=(dev_mode and 1 or 0.33) then
_G.aipSpawnPrefab(inst,"aip_dragon_footprint")
end
end)
end

AddPrefabPostInit("crawlinghorror",createFootPrint)
AddPrefabPostInit("terrorbeak",createFootPrint)
AddPrefabPostInit("crawlingnightmare",createFootPrint)
AddPrefabPostInit("nightmarebeak",createFootPrint)


local function canActOnLiving(inst,doer,target)
return target.prefab=="aip_joker_face"
end

local function onDoLivingTargetAction(inst,doer,target)

if target.components.fueled~=nil then
target.components.fueled:DoDelta(target.components.fueled.maxfuel/5,doer)

if inst.components.stackable~=nil then
inst.components.stackable:Get():Remove()
else
inst:Remove()
end
end
end

AddPrefabPostInit("livinglog",function(inst)

inst:AddComponent("aipc_action_client")
inst.components.aipc_action_client.canActOn=canActOnLiving

if not _G.TheWorld.ismastersim then
return inst
end

inst:AddComponent("aipc_action")
inst.components.aipc_action.onDoTargetAction=onDoLivingTargetAction
end)


local function canActOnGold(inst,doer,target)
return target.prefab=="aip_xinyue_hoe"
end

local function onDoGoldTargetAction(inst,doer,target)

if target.components.fueled~=nil then
target.components.fueled:DoDelta(target.components.fueled.maxfuel,doer)

if inst.components.stackable~=nil then
inst.components.stackable:Get():Remove()
else
inst:Remove()
end
end
end

AddPrefabPostInit("goldnugget",function(inst)

inst:AddComponent("aipc_action_client")
inst.components.aipc_action_client.canActOn=canActOnGold

if not _G.TheWorld.ismastersim then
return inst
end

inst:AddComponent("aipc_action")
inst.components.aipc_action.onDoTargetAction=onDoGoldTargetAction
end)


AddPrefabPostInit("moonglass",function(inst)

inst:AddComponent("aipc_fuel")
end)


AddPrefabPostInit("pigman",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_pigsy",dev_mode and 1 or 0.01)
end
end)


AddPrefabPostInit("bunnyman",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_myth_yutu",dev_mode and 1 or 0.01)
end
end)


AddPrefabPostInit("rabbit",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_myth_yutu",dev_mode and 1 or 0.001)
end
end)


AddPrefabPostInit("monkey",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_monkey_king",dev_mode and 1 or 0.01)
end
end)


AddPrefabPostInit("stalker",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_white_bone",dev_mode and 1 or 0.1)
end
end)

AddPrefabPostInit("skeleton",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_white_bone",dev_mode and 1 or 0.01)
end
end)

AddPrefabPostInit("skeleton_player",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_white_bone",dev_mode and 1 or 0.01)
end
end)


AddPrefabPostInit("ghost",function(inst)

if _G.TheWorld.ismastersim then
if inst.components.lootdropper==nil then
inst:AddComponent("lootdropper")
end

inst.components.lootdropper:AddChanceLoot("aip_xiyou_card_yama_commissioners",dev_mode and 1 or 0.1)
end
end)


AddPrefabPostInit("merm",function(inst)

if _G.TheWorld.ismastersim and inst.components.lootdropper~=nil then
inst.components.lootdropper:AddChanceLoot("aip_22_fish",dev_mode and 1 or 0.001)
end
end)


AddPrefabPostInit("beefalo",function(inst)

if _G.TheWorld.ismastersim and inst.components.periodicspawner~=nil then
local originOnSpawn=inst.components.periodicspawner.onspawn

inst.components.periodicspawner.onspawn=function(inst,prefab,...)
prefab:DoTaskInTime(dev_mode and 2 or 60,function()
local chance=dev_mode and 1 or 0.1
if
prefab:IsValid() and
prefab.prefab=="poop" and
math.random() <=chance and
(
prefab.components.inventoryitem==nil or
prefab.components.inventoryitem:GetContainer()==nil
) and
#_G.aipFindNearEnts(prefab,{ "aip_mud_crab" },20) <=2
then
_G.ReplacePrefab(prefab,"aip_mud_crab")
end
end)

if originOnSpawn~=nil then
return originOnSpawn(inst,prefab,_G.unpack(arg))
end
end
end
end)


AddPrefabPostInit("messagebottle",function(inst)

if additional_food and _G.TheWorld.ismastersim and inst.components.mapspotrevealer~=nil then
local originPrereveal=inst.components.mapspotrevealer.prerevealfn

inst.components.mapspotrevealer.prerevealfn=function(inst,doer,...)
local chance=dev_mode and 1 or 0.05


if
doer~=nil and
doer.components.builder~=nil and
not doer.components.builder:KnowsRecipe("aip_olden_tea") and
math.random() <=chance
then
local blueprint=_G.aipSpawnPrefab(inst,"aip_olden_tea_blueprint")
local bottle=_G.aipSpawnPrefab(inst,"messagebottleempty")


local container=inst.components.inventoryitem:GetContainer()
inst:Remove()

if container~=nil then
container:GiveItem(bottle)
container:GiveItem(blueprint)
end

return false
end

return originPrereveal(inst,doer,_G.unpack(arg))
end
end
end)


AddPrefabPostInit("reskin_tool",function(inst)
if inst.components.spellcaster~=nil then
local originCanCast=inst.components.spellcaster.can_cast_fn
local originSpell=inst.components.spellcaster.spell


if originCanCast and originSpell then
inst.components.spellcaster:SetCanCastFn(function(doer,target,pos,...)
if target.prefab=="aip_wheat" then
return true
end
return originCanCast(doer,target,pos,...)
end)

inst.components.spellcaster:SetSpellFn(function(tool,target,pos,...)
if target and target.prefab=="aip_wheat" then
_G.aipSpawnPrefab(target,"explode_reskin")
_G.aipReplacePrefab(target,"grass")
return
end
return originSpell(tool,target,pos,...)
end)
end
end
end)


AddPrefabPostInit("grass",function(inst)
if not _G.TheWorld.ismastersim then
return inst
end


if additional_food then
if inst.components.pickable~=nil then
local oriPickedFn=inst.components.pickable.onpickedfn

inst.components.pickable.onpickedfn=function(inst,picker,...)
oriPickedFn(inst,picker,...)

local PROBABILITY=dev_mode and 1 or 0.01


if math.random() <=PROBABILITY then
local wheat=_G.aipReplacePrefab(inst,"aip_wheat")
wheat.components.pickable:MakeEmpty()
end
end
end


if inst.components.halloweenmoonmutable==nil then
inst:AddComponent("halloweenmoonmutable")
inst.components.halloweenmoonmutable:SetPrefabMutated("aip_wheat")
end
end
end)


if additional_food and (_G.TheNet:GetIsServer() or _G.TheNet:IsDedicated()) then
AddPrefabPostInit("world",function (inst)

inst:WatchWorldState("season",function ()
for i,player in ipairs(_G.AllPlayers) do
if not player:HasTag("playerghost") and player.entity:IsVisible() then
local pos=_G.aipGetSpawnPoint(player:GetPosition())
if pos~=nil then
local sunflower=_G.SpawnPrefab("aip_sunflower")
sunflower.Transform:SetPosition(pos.x,pos.y,pos.z)
break
end
end
end
end)
end)
end


local VEGGIES=_G.require('prefabs/aip_veggies_list')

for name,data in pairs(VEGGIES) do
env.AddIngredientValues({"aip_veggie_"..name},data.tags or {},data.cancook or false,data.candry or false)
end