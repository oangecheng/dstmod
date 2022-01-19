
local additional_weapon=aipGetModConfig("additional_weapon")

local weapon_damage=aipGetModConfig("weapon_damage")
local language=aipGetModConfig("language")


local USE_TIMES=20

local DAMAGE_MAP={
less=TUNING.CANE_DAMAGE*0.8,
normal=TUNING.CANE_DAMAGE,
large=TUNING.CANE_DAMAGE*1.5,
}

local LANG_MAP={
english={
NAME="Track Measurer",
REC_DESC="Create a shadow track",
DESC="Mixed with moon and shadow",
},
chinese={
NAME="月轨测量仪",
REC_DESC="制作一条暗影轨道",
DESC="暗影与月光的奇艺融合",
},
}

local LANG=LANG_MAP[language] or LANG_MAP.english

TUNING.AIP_TRACK_TOOLE_DAMAGE=DAMAGE_MAP[weapon_damage]


local assets={
Asset("ATLAS","images/inventoryimages/aip_track_tool.xml"),
Asset("ANIM","anim/aip_track_tool.zip"),
Asset("ANIM","anim/aip_track_tool_swap.zip"),
Asset("ANIM","anim/aip_glass_orbit_point.zip"),
}

local prefabs={}


STRINGS.NAMES.AIP_TRACK_TOOL=LANG.NAME
STRINGS.RECIPE_DESC.AIP_TRACK_TOOL=LANG.REC_DESC
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AIP_TRACK_TOOL=LANG.DESC


local function onequip(inst,owner)
owner.AnimState:OverrideSymbol("swap_object","aip_track_tool_swap","aip_track_tool_swap")
owner.SoundEmitter:PlaySound("dontstarve/wilson/equip_item_gold")
owner.AnimState:Show("ARM_carry")
owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst,owner)
owner.AnimState:ClearOverrideSymbol("swap_object")
owner.AnimState:Hide("ARM_carry")
owner.AnimState:Show("ARM_normal")
end


local function onFueled(inst,item,doer)
if inst.components.finiteuses~=nil then
inst.components.finiteuses:Use(-USE_TIMES/4)
end
end


local function canActOnPoint(inst)
return true
end

local function canActOn(inst,doer,target)
return target~=nil and target.prefab=="aip_glass_orbit_point"
end


local function findNearByPoint(pt)
local ents=TheSim:FindEntities(pt.x,0,pt.z,2,{ "aip_glass_orbit_point" })
return ents[1]
end


local function onDoPointAction(inst,creator,targetPos)
local startPos=creator:GetPosition()

aipPrint(inst.components.finiteuses:GetUses())
if inst.components.finiteuses:GetUses()==0 then
return
end


inst.components.finiteuses:Use()


local startP=findNearByPoint(startPos)
if startP==nil then
startP=aipSpawnPrefab(creator,"aip_glass_orbit_point")
aipSpawnPrefab(startP,"aip_shadow_wrapper").DoShow()
end


local endP=findNearByPoint(targetPos)
if endP==nil then
endP=aipSpawnPrefab(nil,"aip_glass_orbit_point",targetPos.x,0,targetPos.z)
aipSpawnPrefab(endP,"aip_shadow_wrapper").DoShow()
end


if startP~=nil and endP~=nil and startP~=endP then


local endPos=endP:GetPosition()
local centerPt=Vector3(
(startPos.x+endPos.x)/2,
0,
(startPos.z+endPos.z)/2
)

local link=aipSpawnPrefab(nil,"aip_glass_orbit_link",centerPt.x,centerPt.y,centerPt.z)
link.components.aipc_orbit_link:Link(startP,endP)
end
end


local function onDoTargetAction(inst,doer,target)
if target==nil then
return
end

local linkList=aipFindEnts("aip_glass_orbit_link")
for i,v in ipairs(linkList) do
if v.components.aipc_orbit_link:Includes(target) then
v:Remove()
end
end

target:Remove()
end

local function CanCastFn(doer,target,pos)
return true
end

local function CreateRail(inst,target,pos)
local owner=inst.components.inventoryitem:GetGrandOwner()
if owner==nil then
return
end

onDoPointAction(inst,owner,pos)
end


function fn()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()

MakeInventoryPhysics(inst)

inst.AnimState:SetBank("aip_track_tool")
inst.AnimState:SetBuild("aip_track_tool")
inst.AnimState:PlayAnimation("idle")

inst:AddTag("allow_action_on_impassable")

inst:AddComponent("aipc_action_client")
inst.components.aipc_action_client.canActOnPoint=canActOnPoint
inst.components.aipc_action_client.canActOn=canActOn


inst:AddComponent("aipc_fueled")
inst.components.aipc_fueled.prefab="moonglass"
inst.components.aipc_fueled.onFueled=onFueled

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end

inst:AddComponent("weapon")
inst.components.weapon:SetDamage(TUNING.AIP_TRACK_TOOLE_DAMAGE)

inst:AddComponent("finiteuses")
inst.components.finiteuses:SetMaxUses(USE_TIMES)
inst.components.finiteuses:SetUses(0)

inst:AddComponent("inspectable")

inst:AddComponent("inventoryitem")
inst.components.inventoryitem.atlasname="images/inventoryimages/aip_track_tool.xml"


inst:AddComponent("aipc_action")
inst.components.aipc_action.onDoPointAction=onDoPointAction
inst.components.aipc_action.onDoTargetAction=onDoTargetAction

MakeHauntableLaunch(inst)

inst:AddComponent("equippable")
inst.components.equippable:SetOnEquip(onequip)
inst.components.equippable:SetOnUnequip(onunequip)

return inst
end

return Prefab("aip_track_tool",fn,assets)