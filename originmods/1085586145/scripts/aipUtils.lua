local _G=GLOBAL


function _G.aipCountTable(tbl)
local count=0
local lastKey=nil
local lastVal=nil
for k,v in pairs(tbl) do
count=count+1
lastKey=k
lastVal=v
end


if lastKey=="n" and type(lastVal)=="number" then
count=count-1
end

return count
end


function _G.aipInTable(tbl,match)
local list=tbl or {}
for i,item in ipairs(list) do
if item==match then
return true
end
end

return false
end


function _G.aipFlattenTable(originTbl)
local targetTbl={}
local tbl=originTbl or {}
local count=_G.aipCountTable(tbl)

local i=1
for i=1,10000 do
local current=tbl[i]
if current~=nil then
table.insert(targetTbl,current)
end

if #targetTbl >=count then
break
end
end

return targetTbl
end

function _G.aipTableRemove(tbl,item)
for i,v in ipairs(tbl) do
if v==item then
table.remove(tbl,i)
end
end
end

function _G.aipTableSlice(tbl,start,len)
local list={}
local finalStart=start or 1
local finalLen=len or #tbl

for i=finalStart,math.min(finalLen+finalStart-1,#tbl) do
table.insert(list,tbl[i])
end
return list
end

function _G.aipTableIndex(tbl,item)
for i,v in ipairs(tbl) do
if v==item then
return i
end
end

return nil
end


function _G.aipFilterTable(originTbl,filterFn)
local tbl={}
for i,v in ipairs(originTbl) do
if filterFn(v,i) then
table.insert(tbl,v)
end
end
return tbl
end



function _G.aipFilterKeysTable(originTbl,keys)
local tbl={}

for k,v in pairs(originTbl) do
if not _G.aipInTable(keys,k) then
tbl[k]=v
end
end

return tbl
end


function _G.aipCommonStr(showType,split,...)
local count=_G.aipCountTable(arg)
local str=""

for i=1,count do
local v=arg[i]
local parsed=v
local vType=type(v)

if showType then

if parsed==nil then
parsed="(nil)"
elseif parsed==true then
parsed="(true)"
elseif parsed==false then
parsed="(false)"
elseif parsed=="" then
parsed="(empty)"
elseif vType=="table" then
local isFirst=true
parsed="{"
for v_k,v_v in pairs(v) do
if not isFirst then
parsed=parsed .. ","
end
isFirst=false

parsed=parsed .. tostring(v_k) .. ":" ..tostring(v_v)
end
parsed=parsed .. "}"
end

if vType=="string" then
str=str.."'"..tostring(parsed).."'"..split
else
str=str .. "[" .. vType .. ": " .. tostring(parsed) .. "]" .. split
end
else

str=str .. tostring(parsed) .. split
end

end

return str
end

function _G.aipCommonPrint(showType,split,...)
local str="[AIP] ".._G.aipCommonStr(showType,split,...)

print(str)

return str
end

function _G.aipStr(...)
return _G.aipCommonStr(false,"",...)
end

function _G.aipPrint(...)
return _G.aipCommonPrint(false," ",...)
end

function _G.aipTypePrint(...)
return _G.aipCommonPrint(true," ",...)
end

_G.aipGetModConfig=GetModConfigData

function _G.aipGetAnimState(inst)
local match=false
local data={}

if inst then
local str=inst.GetDebugString and inst:GetDebugString()
if str then
local bank,build,anim

bank,build,anim=string.match(str,"AnimState: bank: (.*) build: (.*) anim: (.*) anim")
if not anim then
bank,build,anim=string.match(str,"AnimState: bank: (.*) build: (.*) anim: (.*) ..")
end

data.bank=string.split(bank or ""," ")[1]
data.build=string.split(build or ""," ")[1]
data.anim=string.split(anim or ""," ")[1]

if data.bank and data.build and data.anim then
match=true
end
end
end

return match and data or nil
end


function _G.aipSplit(str,spliter)
local list={}
local str=str..spliter
for i in str:gmatch("(.-)"..spliter) do
table.insert(list,i)
end
return list
end



function _G.aipGetAngle(src,tgt)
local direction=(tgt-src):GetNormalized()
local angle=math.acos(direction:Dot(_G.Vector3(1,0,0)))/_G.DEGREES
if direction.z < 0 then
angle=360-angle
end
return angle
end


function _G.aipAngleDist(sourcePos,angle,distance)
local radius=angle/180*_G.PI
return _G.Vector3(sourcePos.x+math.cos(radius)*distance,sourcePos.y,sourcePos.z+math.sin(radius)*distance)
end


function _G.aipDiffAngle(a1,a2)
local min=math.min(a1,a2)
local max=math.max(a1,a2)

local diff1=max-min
local diff2=min+360-max

return math.min(diff1,diff2)
end


function _G.aipDist(p1,p2,includeY)
local dx=p1.x-p2.x
local dz=p1.z-p2.z
local dy=p1.y-p2.y

if includeY then
return math.pow(dx*dx+dy*dy+dz*dz,1/3)
else
return math.pow(dx*dx+dz*dz,0.5)
end
end

function _G.aipRandomEnt(ents)
if #ents==0 then
return nil
end
return ents[math.random(#ents)]
end



function _G.aipFindNearEnts(inst,prefabNames,distance)
local x,y,z=0,0,0
if inst.Transform~=nil then
x,y,z=inst.Transform:GetWorldPosition()
elseif inst.x~=nil and inst.y~=nil and inst.z~=nil then
x=inst.x
y=inst.y
z=inst.z
end
local ents=TheSim:FindEntities(x,0,z,distance or 10)
local prefabs={}

for _,ent in pairs(ents) do
if ent:IsValid() and table.contains(prefabNames,ent.prefab) then
table.insert(prefabs,ent)
end
end

return prefabs
end

function _G.aipFindNearPlayers(inst,dist)
local NOTAGS={ "FX","NOCLICK","DECOR","playerghost","INLIMBO" }
local x,y,z=inst.Transform:GetWorldPosition()
local ents=TheSim:FindEntities(x,0,z,dist,{ "player","_health" },NOTAGS)
return ents
end


function fb(value,defaultValue)
if value~=nil then
return value
end
return defaultValue
end


function _G.aipSpawnPrefab(inst,prefab,tx,ty,tz)
local tgt=_G.SpawnPrefab(prefab)

if tgt==nil then
return nil
end

if inst~=nil then
local x,y,z=inst.Transform:GetWorldPosition()
tgt.Transform:SetPosition(fb(tx,x),fb(ty,y),fb(tz,z))
else
tgt.Transform:SetPosition(fb(tx,0),fb(ty,0),fb(tz,0))
end
return tgt
end


function _G.aipReplacePrefab(inst,prefab,tx,ty,tz)
local tgt=_G.aipSpawnPrefab(inst,prefab,tx,ty,tz)

if tgt==nil then
return nil
end

if inst.components.inventoryitem~=nil then
local container=inst.components.inventoryitem:GetContainer()
local slot=inst.components.inventoryitem:GetSlotNum()

inst:Remove()

if container~=nil then
container:GiveItem(tgt,slot)
end
else
inst:Remove()
end

return tgt
end


function _G.aipGetSpawnPoint(pt,distance)
local dist=distance or 40


local px,py,pz=pt:Get()
if not _G.TheWorld.Map:IsAboveGroundAtPoint(px,py,pz,false) then
pt=_G.FindNearbyLand(pt) or pt
end


local offset=_G.FindWalkableOffset(pt,math.random()*2*_G.PI,dist,12,true)
if offset~=nil then
offset.x=offset.x+pt.x
offset.z=offset.z+pt.z
return offset
end


for i=dist,dist+100,10 do
local nextOffset=_G.FindValidPositionByFan(
math.random()*2*_G.PI,dist,nil,
function(offset)
local x=pt.x+offset.x
local y=pt.y+offset.y
local z=pt.z+offset.z
return _G.TheWorld.Map:IsAboveGroundAtPoint(x,y,z,false)
end
)

if nextOffset~=nil then
nextOffset.x=nextOffset.x+pt.x
nextOffset.z=nextOffset.z+pt.z
return nextOffset
end
end


for i=dist,0,-1 do
local offset=_G.FindWalkableOffset(
pt,math.random()*2*_G.PI,i,12,true,
true,nil,false
)
if offset~=nil then
offset.x=offset.x+pt.x
offset.z=offset.z+pt.z
return offset
end
end

return pt
end

function _G.aipGetSecretSpawnPoint(pt,minDistance,maxDistance,emptyDistance)

if emptyDistance~=nil then
local tgtPT=nil
local tgtEntCnt=99999999

local mergedMaxDistance=maxDistance
if minDistance==maxDistance then
mergedMaxDistance=minDistance+1
end

local step=20/(mergedMaxDistance-minDistance)

for distance=minDistance,maxDistance,step do
local pos=_G.aipGetSpawnPoint(pt,distance)

if pos~=nil then
local ents=TheSim:FindEntities(pos.x,0,pos.z,emptyDistance)
if #ents < tgtEntCnt then
tgtPT=pos
tgtEntCnt=#ents
end
end
end

if tgtPT~=nil then
return tgtPT
end
end

return aipGetSpawnPoint(pt,minDistance)
end


function _G.aipFindRandomPointInOcean(radius,prefabRadius)
local w,h=_G.TheWorld.Map:GetSize()
local halfW=w/2*_G.TILE_SCALE-50
local halfH=h/2*_G.TILE_SCALE-50

local pos=nil
for i=1,100 do
local x=math.random(-halfW,halfW)
local z=math.random(-halfH,halfH)
local rndPos=_G.Vector3(x,0,z)

if _G.aipValidateOceanPoint(rndPos,radius) then
pos=rndPos
break
end
end

return pos
end

function _G.aipValidateOceanPoint(pt,radius,prefabRadius)
radius=radius or 0
prefabRadius=prefabRadius or radius or 0


for rx=pt.x-radius,pt.x+radius,_G.TILE_SCALE*0.8 do
for rz=pt.z-radius,pt.z+radius,_G.TILE_SCALE*0.8 do
if not _G.TheWorld.Map:IsOceanAtPoint(rx,0,rz) then
return false
end
end
end


local ents=TheSim:FindEntities(pt.x,0,pt.z,prefabRadius)
for i,ent in ipairs(ents) do
if not table.contains({
"seastack",
"messagebottle",
"float_fx_back",
"float_fx_front",
"fireflies",
"driftwood_log",
},ent.prefab) then
return false
end
end

return true
end


function _G.aipGetTopologyPoint(tag,prefab,dist)
for i,node in ipairs(_G.TheWorld.topology.nodes) do
if table.contains(node.tags,tag) then
local x=node.cent[1]
local z=node.cent[2]


local ents=TheSim:FindEntities(x,0,z,40)
local fissures=_G.aipFilterTable(ents,function(inst)
return inst.prefab==prefab
end)


local first=fissures[1]
if first~=nil then
return first:GetPosition()
end
end
end

return nil
end

function entMatchNames(prefabNames,ent)
return ent~=nil and ent:IsValid() and table.contains(prefabNames,ent.prefab)
end


function _G.aipFindEnt(...)
for _,ent in pairs(_G.Ents) do

if entMatchNames(arg,ent) then
return ent
end
end

return nil
end

function _G.aipFindEnts(...)
local list={}

for _,ent in pairs(_G.Ents) do

if entMatchNames(arg,ent) then
table.insert(list,ent)
end
end

return list
end

function _G.aipFindRandomEnt(...)
local list=_G.aipFindEnts(...)

return _G.aipRandomEnt(list)
end


_G.aipShadowTags={ "shadow","shadowminion","shadowchesspiece","stalker","stalkerminion","aip_shadowcreature" }

function _G.aipIsShadowCreature(inst)
if not inst then
return false
end

for i,tag in ipairs(_G.aipShadowTags) do
if inst:HasTag(tag) then
return true
end
end
return false
end

function _G.aipCommonStore()
return _G.TheWorld.components~=nil and _G.TheWorld.components.world_common_store
end



function _G.aipRPC(funcName,...)
SendModRPCToServer(MOD_RPC[env.modname][funcName],...)
end


function _G.patchBuffer(inst,name,duration,fn,showFX)
if inst.components.aipc_buffer==nil then
inst:AddComponent("aipc_buffer")
end

inst.components.aipc_buffer:Patch(name,duration,fn,showFX)
end


function _G.hasBuffer(inst,name)




if inst.replica.aipc_buffer~=nil then
return inst.replica.aipc_buffer:HasBuffer(name)
end

return false
end


function _G.aipGetActionableItem(doer)
local inventory=doer.replica.inventory
if inventory~=nil then
local item=inventory:GetEquippedItem(_G.EQUIPSLOTS.HANDS)
if item~=nil and item.components.aipc_action_client~=nil then
return item
end
end
return nil
end