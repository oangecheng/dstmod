local AREA_DISTANCE=2

local SAND_DAMAGE=30

local LOCK_RANGE=4


local COMBAT_TAGS={ "_combat","_health" }

local NO_TAGS={ "NO_TAGS" }


local FLOWERS={ 1,2,3,4 }

local function SpawnFlower(index)




local flower=SpawnPrefab("wormwood_plant_fx")
local rnd=FLOWERS[math.fmod(index,#FLOWERS)+1]
flower:SetVariation(rnd)
return flower
end


local function SpawnCircle(point,dest,list)
local count=#list

for i,prefab in ipairs(list) do
local special=type(prefab)=="string" and SpawnPrefab(prefab) or prefab
local angle=2*PI/count*i
local distance=dest+math.random()/2
special.Transform:SetPosition(point.x+math.cos(angle)*distance,0,point.z+math.sin(angle)*distance)
end
end


local function SpawnFlowers(point,dest,count,flowerIndex)
local list={}

for i=1,count do
table.insert(list,SpawnFlower(flowerIndex+i))
end

SpawnCircle(point,dest,list)
end


local function SpawnGuard(point,element)
local guards={
FIRE={prefab="aip_dou_element_fire_guard"},
ICE={prefab="aip_dou_element_ice_guard"},
SAND={prefab="aip_dou_element_sand_guard"},
HEAL={prefab="aip_dou_element_heal_guard"},
DAWN={prefab="aip_dou_element_dawn_guard"},
COST={prefab="aip_dou_element_cost_guard"},
}

local guard=guards[element]

if guard~=nil then
TheWorld:DoTaskInTime(guard.delay or 0,function()
local guard=SpawnPrefab(guard.prefab)
guard.Transform:SetPosition(point.x,point.y,point.z)
end)
end
end

local function isLine(action)
return action==nil or action=="LINE" or action=="THROUGH"
end

local function ShowEffect(element,point,targetEffect)
local prefab
local normalScale=1
local smallScale=0.5

if element=="FIRE" then
prefab=SpawnPrefab("explode_small")
normalScale=1.2
elseif element=="ICE" then
prefab=SpawnPrefab("icespike_fx_2")
normalScale=2
smallScale=0.7
elseif element=="SAND" then
smallScale=1
if targetEffect then
prefab=SpawnPrefab("sandspike_short")
else
prefab=SpawnPrefab("sandspike_tall")
end


if prefab.components.combat~=nil then
prefab.components.combat:SetDefaultDamage(SAND_DAMAGE)
prefab.components.combat.playerdamagepercent=1
end

if prefab.components.health~=nil then
prefab.components.health:SetInvincible(true)
prefab.components.health:LockInvincible(true)
prefab:DoTaskInTime(4,function()
prefab.components.health:LockInvincible(false)
prefab.components.health:SetInvincible(false)
prefab.components.health:Kill()
end)
end
elseif element=="DAWN" then
prefab=SpawnPrefab("aip_shadow_wrapper")
prefab.DoShow()
normalScale=1.5
smallScale=0.6
elseif element=="HEAL" then
if targetEffect then
prefab=SpawnPrefab("aip_heal_fx")
smallScale=1
else

local flowerIndex=math.floor(math.random()*#FLOWERS)+1
local flower=SpawnFlower(flowerIndex)
flower.Transform:SetPosition(point.x,0,point.z)


local aip_sanity_fx=SpawnPrefab("aip_sanity_fx")
aip_sanity_fx.Transform:SetPosition(point.x,0,point.z)


SpawnFlowers(point,1.5,8,flowerIndex+1)


SpawnFlowers(point,0.5,5,flowerIndex+9)
end
else
prefab=SpawnPrefab("collapse_small")
end

if prefab~=nil then
if targetEffect then
prefab.Transform:SetScale(smallScale,smallScale,smallScale)
else
prefab.Transform:SetScale(normalScale,normalScale,normalScale)
end
prefab.Transform:SetPosition(point.x,point.y,point.z)
end
end

local function ApplyElementEffect(target,element,elementCount)
if element=="FIRE" and math.random() < (elementCount or 0)*.4 then

if target.components.burnable~=nil and not target.components.burnable:IsBurning() then
if target.components.freezable~=nil and target.components.freezable:IsFrozen() then
target.components.freezable:Unfreeze()
elseif target.components.fueled==nil
or (target.components.fueled.fueltype~=FUELTYPE.BURNABLE and
target.components.fueled.secondaryfueltype~=FUELTYPE.BURNABLE) then
--does not take burnable fuel,so just burn it
if target.components.burnable.canlight or target.components.combat~=nil then
target.components.burnable:Ignite(true)
end
elseif target.components.fueled.accepting then
--takes burnable fuel,so fuel it
local fuel=SpawnPrefab("cutgrass")
if fuel~=nil then
if fuel.components.fuel~=nil and
fuel.components.fuel.fueltype==FUELTYPE.BURNABLE then
target.components.fueled:TakeFuelItem(fuel)
else
fuel:Remove()
end
end
end
end
elseif element=="ICE" then

if target.components.freezable~=nil then
target.components.freezable:AddColdness(elementCount or 1)
target.components.freezable:SpawnShatterFX()
end
end
end

local Projectile=Class(function(self,inst)
self.inst=inst
self.speed=20
self.launchoffset=Vector3(0,1.6,0)

self.doer=nil
self.queue={}


self.task=nil
self.source=nil
self.sourcePos=nil
self.target=nil
self.targetPos=nil
self.distance=nil
self.cachePos=nil
self.diffTime=nil


inst:DoTaskInTime(120,function()
self:CleanUp()
end)
end)

function Projectile:CleanUp()
self.inst:StopUpdatingComponent(self)
self.inst:Remove()
end

function Projectile:FindEntities(element,pos,radius,excludePrefabs)
local filteredEnts={}
local ents=TheSim:FindEntities(pos.x,pos.y,pos.z,radius or AREA_DISTANCE,COMBAT_TAGS,NO_TAGS)

for i,ent in ipairs(ents) do

if
not aipInTable(excludePrefabs,ent) and
ent:IsValid() and ent.entity:IsVisible() and
ent.components.combat and
ent.components.health and not ent.components.health:IsDead() and not ent.components.health:IsInvincible()
then
table.insert(filteredEnts,ent)
end
end

return filteredEnts
end

function Projectile:RotateToTarget(dest)
local angle=aipGetAngle(self.inst:GetPosition(),dest)
self.inst.Transform:SetRotation(angle)
self.inst:FacePoint(dest)
end



function Projectile:StartBy(doer,queue,target,targetPos,replaceSourcePos)
local task=queue[1]

if task==nil then
self:CleanUp()
return
end

local splitCount=task.split+1


local ents={}
if task.action=="FOLLOW" and target~=nil then
local tmpEnts=self:FindEntities(task.element,target:GetPosition(),8)

for i,prefab in ipairs(tmpEnts) do
if prefab~=target then
table.insert(ents,prefab)
end
end
end

for i=1,splitCount do
local effectProjectile=SpawnPrefab("aip_dou_scepter_projectile")


if task.action=="FOLLOW" then

if i==1 then

effectProjectile.components.aipc_dou_projectile:StartEffectTask(doer,queue,target,targetPos,replaceSourcePos)
else

local newTarget=ents[i-1]
if newTarget~=nil then
effectProjectile.components.aipc_dou_projectile:StartEffectTask(doer,queue,newTarget,newTarget:GetPosition(),replaceSourcePos)
end
end
else

local sourcePos=replaceSourcePos or doer:GetPosition()
local angle=(aipGetAngle(sourcePos,targetPos)+((i-1)-(splitCount-1)/2)*30)
local distance=math.pow(distsq(sourcePos.x,sourcePos.z,targetPos.x,targetPos.z),0.5)
local newTargetPos=aipAngleDist(sourcePos,angle,distance)

effectProjectile.components.aipc_dou_projectile:StartEffectTask(doer,queue,target,newTargetPos,replaceSourcePos)
end
end


self:CleanUp()
end


function Projectile:StartEffectTask(doer,queue,target,targetPos,replaceSourcePos)
self.inst.Physics:ClearCollidesWith(COLLISION.LIMITS)
self.doer=doer
self.queue=queue
self.source=doer
self.sourcePos=replaceSourcePos or doer:GetPosition()
self.target=target
self.targetPos=targetPos
self.cachePos=doer:GetPosition()

if self.target and not self.targetPos then
self.targetPos=self.target:GetPosition()
end


local x,y,z=self.sourcePos:Get()
local facing_angle=doer.Transform:GetRotation()*DEGREES
self.inst.Physics:Teleport(x+self.launchoffset.x*math.cos(facing_angle),y+self.launchoffset.y,z-self.launchoffset.x*math.sin(facing_angle))


self:RotateToTarget(self.targetPos)
self.inst.Physics:SetVel(0,0,0)
self.inst.Physics:SetFriction(0)
self.inst.Physics:SetDamping(0)
self.inst.Physics:SetMotorVel(self.speed,1,0)


self:CalculateTask()
self.inst:StartUpdatingComponent(self)
end


function Projectile:CalculateTask()
local task=self.queue[1]

if task==nil then
self:CleanUp()
return
end


local color=task.color
self.inst.components.aipc_info_client:SetByteArray("aip_projectile_color",{ color[1]*10,color[2]*10,color[3]*10,color[4]*10 })

self.task=task
self.diffTime=0
self.affectedEntities={}
self.inst.AnimState:SetMultColour(1,1,1,1)

if isLine(self.task.action) then
self.distance=10
elseif self.task.action=="AREA" then
self.inst.AnimState:SetMultColour(0,0,0,0)
end
end


function Projectile:DoNextTask()
local newQueue={}
local prevTask=self.queue[1]


for i=2,#self.queue do
local task=self.queue[i]
table.insert(newQueue,task)
end

if #newQueue >=1 then
local nextTask=newQueue[1]
local nextProjectile=SpawnPrefab("aip_dou_scepter_projectile")
local nextPos=nil
local nextTarget=nil


local targetPos=self.targetPos

local replaceSourcePos=targetPos
local diffX=targetPos.x-self.sourcePos.x
local diffZ=targetPos.z-self.sourcePos.z

if nextTask.action=="AREA" then

nextPos=Vector3(targetPos.x+math.min(4,diffX/2),targetPos.y,targetPos.z+math.min(4,diffZ/2))
elseif nextTask.action=="FOLLOW" then

local ents=self:FindEntities(nextTask.element,targetPos,8)


local bestTarget=nil
local bestDistance=999999

for i,prefab in ipairs(ents) do
local prefabPos=prefab:GetPosition()
local sq=distsq(targetPos.x,targetPos.z,prefabPos.x,prefabPos.z)
local dst=math.abs(math.pow(sq,0.5)-4)

if prefab~=self.target and dst < bestDistance then
bestTarget=prefab
bestDistance=dst
end
end

if bestTarget==nil and self.target~=nil then
bestTarget=self.target
end


if bestTarget==nil then
self:CleanUp()
return
end

nextTarget=bestTarget
nextPos=nextTarget:GetPosition()
else

nextPos=Vector3(targetPos.x+diffX*100,targetPos.y,targetPos.z+diffZ*100)


if prevTask.action=="AREA" then
local angle=aipGetAngle(targetPos,nextPos)
local radius=angle/180*PI
replaceSourcePos=Vector3(targetPos.x+math.cos(radius)*AREA_DISTANCE,targetPos.y,targetPos.z+math.sin(radius)*AREA_DISTANCE)
end
end

nextProjectile.components.aipc_dou_projectile:StartBy(self.doer,newQueue,nextTarget,nextPos,replaceSourcePos)
end

self:CleanUp()
end


function Projectile:EffectTaskOn(target)
local doEffect=false

if self.task.element=="HEAL" then
if target.components.health~=nil then
target.components.health:DoDelta(self.task.damage,false,self.inst.prefab)
doEffect=true
end


else
local finalDamage=self.task.damage


if self.task.element=="DAWN" and aipIsShadowCreature(target) and target.components.health then
finalDamage=finalDamage+self.task.elementCount*50
end


if self.task.element=="COST" then
finalDamage=finalDamage*math.pow(1.5,self.task.elementCount)
end

target.components.combat:GetAttacked(self.doer,finalDamage,nil,nil)
doEffect=true


if self.task.vampire then
local proj=SpawnPrefab("aip_projectile")
proj.components.aipc_info_client:SetByteArray(
"aip_projectile_color",{ 4,0,3,5 }
)

local x,y,z=target.Transform:GetWorldPosition()

proj.Transform:SetPosition(x,1,z)
proj.components.aipc_projectile.speed=10
proj.components.aipc_projectile:GoToTarget(self.doer,function()
if
self.doer.components.health~=nil and not self.doer.components.health:IsDead() and
self.doer:IsValid() and not self.doer:IsInLimbo()
then
self.doer.components.health:DoDelta(10)
end
end)
end


if
self.task.element=="COST" and
target.components.health~=nil and
not target.components.health:IsDead() and
self.doer~=self.target
then
local proj=SpawnPrefab("aip_projectile")
proj.components.aipc_info_client:SetByteArray(
"aip_projectile_color",{ 0.5,0,0,5 }
)

local x,y,z=target.Transform:GetWorldPosition()

proj.Transform:SetPosition(x,1,z)
proj.components.aipc_projectile.speed=10
proj.components.aipc_projectile:GoToTarget(self.doer,function()
if
self.doer.components.health~=nil and not self.doer.components.health:IsDead() and
self.doer:IsValid() and not self.doer:IsInLimbo()
then
self.doer.components.health:DoDelta(-finalDamage*0.1)
end
end)
end
end

if doEffect then
ApplyElementEffect(target,self.task.element,self.task.elementCount)
end

return doEffect
end


function Projectile:EffectTaskOnPoint(projPT)

if self.task.lock then
aipSpawnPrefab(nil,"aip_aura_lock",projPT.x,projPT.y,projPT.z)

local ents=self:FindEntities(nil,projPT,LOCK_RANGE)
for i,ent in ipairs(ents) do
if ent.components.aipc_dou_lock==nil then
ent:AddComponent("aipc_dou_lock")
end

ent.components.aipc_dou_lock:LockTo(projPT)
end
end
end

function Projectile:OnUpdate(dt)

if self.task==nil then
self:CleanUp()
return
end

self.diffTime=self.diffTime+dt

local currentPos=self.inst:GetPosition()
local finishTask=false


if isLine(self.task.action) then
local ents=self:FindEntities(self.task.element,self.inst:GetPosition(),nil,self.affectedEntities)


ents=aipFilterTable(ents,function(inst)
return self.doer~=inst
end)

if #ents > 0 then
self:EffectTaskOnPoint(currentPos)
end


for i,prefab in ipairs(ents) do
if
prefab:IsValid() and
prefab.entity:IsVisible() and
prefab.components.combat~=nil and
prefab.components.health~=nil
then
local effectWork=self:EffectTaskOn(prefab)


if effectWork then
table.insert(self.affectedEntities,prefab)
end

if self.task.action~="THROUGH" then
finishTask=effectWork or finishTask


if effectWork then
self.target=prefab
self.targetPos=self.target:GetPosition()
end
end

ShowEffect(self.task.element,prefab:GetPosition(),true)
end
end


self.distance=self.distance-self.speed*dt
if self.distance < 0 then
finishTask=true


self.targetPos=self.inst:GetPosition()
self.targetPos.y=0


if finishTask and self.task.guard >=1 and #self.affectedEntities==0 then
SpawnGuard(self.targetPos,self.task.element)
end
end


elseif self.task.action=="FOLLOW" then
if self.target==nil or self.target.components.health==nil or self.target.components.health:IsDead() then
finishTask=true
else

local targetPos=self.target:GetPosition()
self.targetPos=targetPos

if aipDist(currentPos,targetPos) < 1.5 then
self:EffectTaskOnPoint(targetPos)
finishTask=self:EffectTaskOn(self.target) or finishTask
ShowEffect(self.task.element,self.target:GetPosition())
else
self:RotateToTarget(self.targetPos)
end
end


elseif self.task.action=="AREA" then

if self.diffTime >=0.1 then
local ents=self:FindEntities(self.task.element,self.targetPos)
self:EffectTaskOnPoint(self.targetPos)


for i,prefab in ipairs(ents) do
self:EffectTaskOn(prefab)

if self.task.element=="HEAL" then
ShowEffect(self.task.element,prefab:GetPosition(),true)
end
end


if (#ents==0 or self.task.element=="SAND") and self.task.guard >=1 then
SpawnGuard(self.targetPos,self.task.element)
end

finishTask=true
end

if finishTask then

if self.task.element~="SAND" or self.task.guard==0 then
ShowEffect(self.task.element,self.targetPos)
end
end
end

if finishTask then
self:DoNextTask()
end

self.cachePos=currentPos
end


return Projectile