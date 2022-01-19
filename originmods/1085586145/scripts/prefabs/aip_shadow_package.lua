require "prefabutil"

local foldername=KnownModIndex:GetModActualName(TUNING.ZOMBIEJ_ADDTIONAL_PACKAGE)



local additional_magic=aipGetModConfig("additional_magic")
if additional_magic~="open" then
return nil
end


local dev_mode=aipGetModConfig("dev_mode")=="enabled"

local language=aipGetModConfig("language")

local LANG_MAP={
english={
NAME="Shadow Package",
DESC="Package your building",
DESCRIBE="It's wrapped with something!",

PAPER_NAME="Shadow Package Rune",
PAPER_DESCRIBE="Put it on a building",
},
chinese={
NAME="暗影打包带",
DESC="用于打包你的建筑",
DESCRIBE="它蕴含着某种东西",

PAPER_NAME="暗影打包符文",
PAPER_DESCRIBE="把它放到建筑上",
},
russian={
NAME="Теневой пакет",
DESC="Упакуйте свое строение",
DESCRIBE="Он чем-то обернут!",

PAPER_NAME="Руна Теневого пакета",
PAPER_DESCRIBE="Повесьте её на строение",
},
}

local LANG=LANG_MAP[language] or LANG_MAP.english
local LANG_ENG=LANG_MAP.english


STRINGS.NAMES.AIP_SHADOW_PACKAGE=LANG.NAME or LANG_ENG.NAME
STRINGS.RECIPE_DESC.AIP_SHADOW_PACKAGE=LANG.DESC or LANG_ENG.DESC
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AIP_SHADOW_PACKAGE=LANG.DESCRIBE or LANG_ENG.DESCRIBE

STRINGS.NAMES.AIP_SHADOW_PAPER_PACKAGE=LANG.PAPER_NAME or LANG_ENG.PAPER_NAME
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AIP_SHADOW_PAPER_PACKAGE=LANG.PAPER_DESCRIBE or LANG_ENG.PAPER_DESCRIBE


local aip_shadow_package=Recipe("aip_shadow_package",{Ingredient("waxpaper",1),Ingredient("nightmarefuel",5),Ingredient("featherpencil",1)},RECIPETABS.MAGIC,TECH.MAGIC_TWO)
aip_shadow_package.atlas="images/inventoryimages/aip_shadow_package.xml"


local assets=
{
Asset("ATLAS","images/inventoryimages/aip_shadow_package.xml"),
Asset("ATLAS","images/inventoryimages/aip_shadow_paper_package.xml"),
Asset("ANIM","anim/aip_shadow_package.zip"),
}

local prefabs=
{
"aip_shadow_wrapper",
}

function fn_common(name,preFunc,postFunc)
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()

MakeInventoryPhysics(inst)

inst.AnimState:SetBank("aip_shadow_package")
inst.AnimState:SetBuild("aip_shadow_package")

inst:AddTag("bundle")
inst:AddTag("aip_package")

inst.entity:SetPristine()

inst:AddComponent("aipc_info_client")

if preFunc then
preFunc(inst)
end

if not TheWorld.ismastersim then
return inst
end

inst:AddComponent("inspectable")

inst:AddComponent("inventoryitem")
inst.components.inventoryitem.atlasname=aipStr("images/inventoryimages/",name,".xml")

inst:AddComponent("aipc_action")

MakeHauntableLaunch(inst)

if postFunc then
postFunc(inst)
end

return inst
end

local function removeFromScene(inst)
if not inst then
return
end

inst:RemoveFromScene()

return inst
end


local function doPackage(inst,doer,target)
if not inst or not doer or not target then
return
end

local x,y,z=inst.Transform:GetWorldPosition()
local tx,ty,tz=target.Transform:GetWorldPosition()
inst:Remove()


local item=SpawnPrefab("aip_shadow_package")
item:Hide()
item.packageTarget=target
local holder=doer~=nil and (doer.components.inventory or doer.components.container) or nil


if doer.components.sanity then
doer.components.sanity:DoDelta(-TUNING.SANITY_MED)
end


local shadowWrapper=SpawnPrefab("aip_shadow_wrapper")
shadowWrapper.Transform:SetPosition(tx,ty+0.1,tz)
shadowWrapper.OnFinish=function()
item:Show()
if holder~=nil then
holder:GiveItem(item)
else
item.Transform:SetPosition(x,y,z)
end


removeFromScene(target)
end

shadowWrapper.DoHide()
end


local function onPaperLoad(inst)
local x,y,z=inst.Transform:GetWorldPosition()
if
x==0 and y==0 and z==0 and
(inst.components.inventoryitem==nil or inst.components.inventoryitem:GetContainer()==nil)
then
inst:Remove()
end
end

function fnPaper()
return fn_common("aip_shadow_paper_package",function(inst)

inst.AnimState:PlayAnimation("paper",true)
inst:AddTag("aip_proxy_action")
end,function(inst)

inst.components.aipc_action.onDoTargetAction=doPackage
inst.OnLoad=onPaperLoad
end)
end


local function stopChechPackaged(inst)
if inst and inst._delayCheck then
inst._delayCheck:Cancel()
inst._delayCheck=nil
end
end


local function delayCheckPackaged(inst,delay)
if not inst then
return
end

stopChechPackaged(inst)

inst._delayCheck=inst:DoTaskInTime(delay or 0,function()
if inst.packageTarget then
return
end

inst:AddComponent("perishable")
inst.components.perishable.onperishreplacement="aip_shadow_paper_package"
inst:DoTaskInTime(0,function()
inst.components.perishable:Perish()
end)
end)
end


local function onPackageSave(inst,data)
if inst.packageTarget then
local tx,ty,tz=inst.packageTarget.Transform:GetWorldPosition()
local prefab=inst.packageTarget.prefab

data.targetX=tx
data.targetY=ty
data.targetZ=tz
data.prefab=prefab
else
data.prefab=nil
end
end


local function onPackageLoad(inst,data)
stopChechPackaged(inst)

local prefab=data.prefab
local tx=data.targetX or 0
local ty=data.targetY or 0
local tz=data.targetZ or 0

local entities=TheSim:FindEntities(tx,ty,tz,0.1,{ "structure" })

local target=nil
for k,v in pairs(entities) do
if v.prefab==prefab then
target=v
break
end
end

if target then
inst.packageTarget=removeFromScene(target)
end

delayCheckPackaged(inst)
end

local function onDeploy(inst,pt,deployer)
if not inst.packageTarget then
return
end

local target=inst.packageTarget
target:ReturnToScene()
if target.Physics then
target.Physics:Teleport(pt.x,pt.y,pt.z)
else
target.Transform:SetPosition(pt.x,pt.y,pt.z)
end


inst.packageTarget=nil
if dev_mode then
delayCheckPackaged(inst)
else
inst:Remove()
end


local paper=SpawnPrefab("aip_shadow_paper_package")
local holder=deployer~=nil and (deployer.components.inventory or deployer.components.container) or nil
if holder~=nil then
holder:GiveItem(paper)
else
paper.Transform:SetPosition(pt.x,pt.y,pt.z)
end


if deployer.components.sanity then
deployer.components.sanity:DoDelta(-TUNING.SANITY_MED)
end


local shadowWrapper=SpawnPrefab("aip_shadow_wrapper")
shadowWrapper.Transform:SetPosition(pt.x,pt.y+0.1,pt.z)

shadowWrapper.DoShow()
end

function fnPackage()
return fn_common("aip_shadow_package",function(inst)

inst.AnimState:PlayAnimation("idle",true)
end,function(inst)

inst:AddComponent("deployable")
inst.components.deployable.ondeploy=onDeploy
inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

inst.OnSave=onPackageSave
inst.OnLoad=onPackageLoad


delayCheckPackaged(inst)
end)
end


local function postPlacer(inst)
inst:DoTaskInTime(0,function()
if inst.components.placer and inst.components.placer.invobject then
local package=inst.components.placer.invobject
local animState=aipGetAnimState(package.packageTarget)

if animState then
inst.AnimState:SetBank(animState.bank)
inst.AnimState:SetBuild(animState.build)
inst.AnimState:PlayAnimation(animState.anim)
end
end
end)
end

return Prefab("aip_shadow_paper_package",fnPaper,assets,prefabs),
Prefab("aip_shadow_package",fnPackage,assets,prefabs),
MakePlacer("aip_shadow_package_placer","aip_shadow_package","aip_shadow_package","idle",nil,nil,nil,nil,nil,nil,postPlacer)














































































