local dev_mode=aipGetModConfig("dev_mode")=="enabled"

local createProjectile=require("utils/aip_vest_util").createProjectile


local FX_OFFSET=2
local FX_HEIGHT=7

local function getPos(idx)
local mathIdx=idx-1
local y=math.floor(mathIdx/9)
local x=math.floor(math.mod(mathIdx,9)/3)
local z=math.mod(mathIdx,3)

return x-1,y-1,z-1
end

local function getPosVec(idx)
local x,y,z=getPos(idx)
return Vector3(x,y,z)
end

local function getIndex(pt)
local x=pt.x+1
local y=pt.y+1
local z=pt.z+1
return y*9+x*3+z+1
end

local function getSameCount(x1,y1,z1,x2,y2,z2)
local sameX=x1==x2
local sameY=y1==y2
local sameZ=z1==z2
local sameCnt=(sameX and 1 or 0)+(sameY and 1 or 0)+(sameZ and 1 or 0)
return sameCnt
end

local function isCorner(x,y,z)
return math.abs(x)==1 and math.abs(y)==1 and math.abs(z)==1
end


local function getSameAxis(p1,p2)
local axises={}
local xyz={'x','y','z'}
for i,axis in ipairs(xyz) do
if p1[axis]==p2[axis] then
table.insert(axises,axis)
end
end
return axises
end


local function isEdgeCenter(x,y,z)
return math.abs(x)+math.abs(y)+math.abs(z)==2
end


local function isFaceCenter(x,y,z)
return math.abs(x)+math.abs(y)+math.abs(z)==1
end


local function revertPT(axis,x,y,z)
if type(x)=="table" then
z=x.z
y=x.y
x=x.x
end

local pt=Vector3(x,y,z)
pt[axis]=-pt[axis]
return pt
end


local function setPT(axis,pt,val)
local clone=Vector3(pt.x,pt.y,pt.z)
clone[axis]=val
return clone
end


local function offsetPT(axis,pt,offset)
local val=pt[axis]+offset
return setPT(axis,pt,val)
end


local function getAxisRest(axis)
local tbl={
x={ 'y','z' },
y={ 'z','x' },
z={ 'x','y' },
}
return tbl[axis]
end


local function rotateFace(originFxs,originMatrix,fixedAxis,fixedAxisPos,reverse)
local angle=PI/2
local restAxises=getAxisRest(fixedAxis)

if reverse then
angle=-angle
end

local next_fxs=aipTableSlice(originFxs)
local next_matrix=aipTableSlice(originMatrix)

for x=-1,1 do
for y=-1,1 do

local nextX=math.floor(x*math.cos(angle)-y*math.sin(angle)+0.1)
local nextY=math.floor(x*math.sin(angle)+y*math.cos(angle)+0.1)
local xyz=Vector3()
xyz[fixedAxis]=fixedAxisPos
xyz[restAxises[1]]=x
xyz[restAxises[2]]=y


local nextXYZ=Vector3(xyz.x,xyz.y,xyz.z)
nextXYZ[restAxises[1]]=nextX
nextXYZ[restAxises[2]]=nextY




local oriIdx=getIndex(xyz)
local tgtIdx=getIndex(nextXYZ)

next_fxs[tgtIdx]=originFxs[oriIdx]
next_matrix[tgtIdx]=originMatrix[oriIdx]
end
end

return {
fxs=next_fxs,
matrix=next_matrix,
}
end


local function rotateDist(fxs,next_fxs,startPT,endPT)
local startRotatedIdx=aipTableIndex(next_fxs,fxs[getIndex(startPT)])
local startRotatedPos=getPosVec(startRotatedIdx)
return aipDist(startRotatedPos,endPT,true)
end


local function playAnimation(fx,motion)
if fx then
fx.AnimState:PlayAnimation(motion,true)

if motion=="optional" then
fx.rotate=true
end
end
end


local function getAxisByVal(pt,val)
if pt.x==val then
return 'x'
elseif pt.y==val then
return 'y'
elseif pt.z==val then
return 'z'
end
end


local function isOnAxis(axis,pt)
if axis=='x' then
return pt.y==0 and pt.z==0
elseif axis=='y' then
return pt.x==0 and pt.z==0
elseif axis=='z' then
return pt.x==0 and pt.y==0
end
end


local Rubik=Class(function(self,inst)
self.inst=inst

self.start=false
self.selectIndex=nil
self.fxs={}

self.matrix={}
self.randomTimes=10
self.summonning=false

local colors={"red","green","blue"}
for y=0,2 do
local color=colors[y+1]

for x=0,2 do
for z=0,2 do
local idx=1+z+x*3+y*9
local finalColor=color
if isFaceCenter(x-1,y-1,z-1) or (x==1 and y==1 and z==1) then
finalColor="yellow"
end
self.matrix[idx]=finalColor
end
end
end
end)


function Rubik:CreateMonster(count)
local pt=self.inst:GetPosition()
local dist=7


local heart=aipSpawnPrefab(self.inst,"aip_rubik_heart")
heart.aipGhosts={}


for i=1,count do
local angle=2*PI/count*i
local tgtPT=Vector3(
pt.x+math.cos(angle)*dist,0,pt.z+math.sin(angle)*dist
)

createProjectile(
self.inst,tgtPT,function(proj)
local effect=aipSpawnPrefab(proj,"aip_shadow_wrapper",nil,0.1)
effect.DoShow()

local ghost=aipSpawnPrefab(proj,"aip_rubik_ghost")
if ghost.components.knownlocations then
ghost.components.knownlocations:RememberLocation("home",pt)
end

ghost.aipHeart=heart
table.insert(heart.aipGhosts,ghost)
end,{ 0,0,0,5 },10
)
end
end



function Rubik:SummonBoss()
local passedLevelCount=0

for y=-1,1 do
local commonColor=nil
local passed=true

for x=-1,1 do
for z=-1,1 do
local index=getIndex(Vector3(x,y,z))
local color=self.matrix[index]

if color~="yellow" then

if commonColor==nil then
commonColor=color
end


if commonColor~=color then
passed=false
end
end
end
end

if passed then
passedLevelCount=passedLevelCount+1
end
end


local x,y,z=self.inst.Transform:GetWorldPosition()
local pt=Vector3(x,y+1.5,z)

for i,fx in ipairs(self.fxs) do
fx.components.aipc_float:MoveToPoint(pt)
end

self.summonning=true
self.selectIndex=nil

self.inst:DoTaskInTime(0.5,function()
if self.inst.components.fueled~=nil then
self.inst.components.fueled:MakeEmpty()
end


local effect=aipSpawnPrefab(self.inst,"aip_shadow_wrapper",nil,0.1)
effect.DoShow(2)


self:CreateMonster(1+(3-passedLevelCount)*2)


local replacedRubik=aipReplacePrefab(self.inst,"aip_rubik")
if replacedRubik.components.fueled~=nil then
replacedRubik.components.fueled:MakeEmpty()
end
end)
end


function Rubik:SyncPos(motion)

self.inst:DoTaskInTime(0.1,function()
local x,y,z=self.inst.Transform:GetWorldPosition()

for i,fx in ipairs(self.fxs) do
local ox,oy,oz=getPos(i)

local scaleOffset=1+(oy-1)/6

local tgtX=x+ox*FX_OFFSET*scaleOffset
local tgtY=y+oy*FX_OFFSET+FX_HEIGHT
local tgtZ=z+oz*FX_OFFSET*scaleOffset

local pt=Vector3(tgtX,tgtY,tgtZ)

if i==2 then
fx.components.aipc_float.debug=true
end

if motion then
fx.components.aipc_float:MoveToPoint(pt)
else
fx.components.aipc_float:GoToPoint(pt)
end
end
end)
end

function Rubik:SyncHighlight()
for i,fx in ipairs(self.fxs) do
local ox,oy,oz=getPos(i)

playAnimation(fx,"idle")
fx.rotate=false

if ox==0 and oy==0 and oz==0 then
fx:AddTag("FX")
else
fx:RemoveTag("FX")
end
end

if self.selectIndex then

local selected=self.fxs[self.selectIndex]
playAnimation(selected,"selected")


local sx,sy,sz=getPos(self.selectIndex)



if isCorner(sx,sy,sz) then
local ptXY=revertPT('x',revertPT('y',sx,sy,sz))
ptXY.lock='z'
local ptYZ=revertPT('y',revertPT('z',sx,sy,sz))
ptYZ.lock='x'
local ptXZ=revertPT('z',revertPT('x',sx,sy,sz))
ptXZ.lock='y'

local ptList={ ptXY,ptYZ,ptXZ }
for i,pt in ipairs(ptList) do
local restAxises=getAxisRest(pt.lock)

for i,restAxis in ipairs(restAxises) do
local finalPT=setPT(restAxis,pt,0)
local idx=getIndex(finalPT)
playAnimation(self.fxs[idx],"optional")
end
end
end


if isEdgeCenter(sx,sy,sz) then

local pt=Vector3(sx,sy,sz)
local fixAxis=getAxisByVal(pt,0)
local restAxises=getAxisRest(fixAxis)


for i,restAxis in ipairs(restAxises) do
local finalPT=setPT(restAxis,pt,0)
local idx=getIndex(finalPT)
playAnimation(self.fxs[idx],"optional")
end


local pt1=setPT(fixAxis,pt,-1)
local pt2=setPT(fixAxis,pt,1)
local ptList={ pt1,pt2 }
for i,pt in ipairs(ptList) do
for i,restAxis in ipairs(restAxises) do
local finalPT=setPT(restAxis,pt,0)
local idx=getIndex(finalPT)
playAnimation(self.fxs[idx],"optional")
end
end
end


if isFaceCenter(sx,sy,sz) then
local pt=Vector3(sx,sy,sz)
local fixAxis=getAxisByVal(pt,1) or getAxisByVal(pt,-1)
local restAxises=getAxisRest(fixAxis)

for i,restAxis in ipairs(restAxises) do
local pt1=setPT(restAxis,pt,-1)
local pt2=setPT(restAxis,pt,1)
local ptList={ pt1,pt2 }
for i,finalPT in ipairs(ptList) do
local idx=getIndex(finalPT)
playAnimation(self.fxs[idx],"optional")
end
end
end
end
end


function Rubik:Start()
self.start=true

if #self.fxs==0 then
for i,color in ipairs(self.matrix) do
local fx=SpawnPrefab("aip_rubik_fire_"..color)
fx.aipRubik=self.inst
self.fxs[i]=fx
end
end

self:SyncPos()
self:SyncHighlight()


self:TryRandom()
end

function Rubik:TryRandom()
if self.randomTimes > 0 then
self.randomTimes=self.randomTimes-1

local axises={ "x","y","z" }
local axis=dev_mode and 'x' or axises[math.random(#axises)]

local rndPos=0
repeat
rndPos=math.random(-1,1)
until(rndPos~=self.randomPos)

local walkingInfo=rotateFace(self.fxs,self.matrix,axis,rndPos)
self.fxs=walkingInfo.fxs
self.matrix=walkingInfo.matrix

self.selectIndex=nil
self:SyncPos(true)
self:SyncHighlight()


self.randomPos=rndPos


self.inst:DoTaskInTime(0.3,function()
self:TryRandom()
end)
end
end

function Rubik:Stop()
self.start=false

for i,fx in ipairs(self.fxs) do
fx:Remove()
end

self.fxs={}
end


function Rubik:Select(fire)

if self.randomTimes > 0 or self.summonning then
return
end

local prevIndex=self.selectIndex

self.selectIndex=aipTableIndex(self.fxs,fire)


if self.selectIndex==14 or prevIndex==self.selectIndex then
self.selectIndex=nil
end


if prevIndex and self.selectIndex and fire.rotate then
local pStart=getPosVec(prevIndex)
local pEnd=getPosVec(self.selectIndex)




local axises=getSameAxis(pStart,pEnd)
for i,axis in ipairs(axises) do

if not isOnAxis(axis,pStart) and not isOnAxis(axis,pEnd) then
local fixedAxisPos=pEnd[axis]


local walkingInfo=rotateFace(self.fxs,self.matrix,axis,fixedAxisPos)
local reverseWalkingInfo=rotateFace(self.fxs,self.matrix,axis,fixedAxisPos,true)


local rotatedDist=rotateDist(self.fxs,walkingInfo.fxs,pStart,pEnd)


local reverseRotatedDist=rotateDist(self.fxs,reverseWalkingInfo.fxs,pStart,pEnd)


if rotatedDist < reverseRotatedDist then
self.fxs=walkingInfo.fxs
self.matrix=walkingInfo.matrix
else
self.fxs=reverseWalkingInfo.fxs
self.matrix=reverseWalkingInfo.matrix
end
self:SyncPos(true)


self.selectIndex=nil
end
end
end


self:SyncHighlight()
end

return Rubik