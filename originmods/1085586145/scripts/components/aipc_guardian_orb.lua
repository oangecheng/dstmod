local RETARGET_MUST_TAGS={ "_combat","_health" }
local RETARGET_CANT_TAGS={ "INLIMBO","player","engineering" }

local ORB_SPEED=9
local ORB_SPEED_FAST=20
local ANGLE_SPEED=360
local MAX_COUNT=3
local INCREASE_TIMEOUT=2
local DISTANCE=1.5
local DISTANCE_FAST=2
local PROJECTILE_INTERVAL=0.6


local function getTargetPoint(angle,pos,offset)
local offsetAngle=angle+(360/MAX_COUNT*offset)
local radius=offsetAngle/180*PI
local targetPos=Vector3(pos.x+math.cos(radius)*DISTANCE,pos.y,pos.z+math.sin(radius)*DISTANCE)
return targetPos
end


local function findNearEnemy(inst,owner)
local x,y,z=inst.Transform:GetWorldPosition()
local ents=TheSim:FindEntities(x,y,z,TUNING.AIP_JOKER_FACE_MAX_RANGE,RETARGET_MUST_TAGS,RETARGET_CANT_TAGS)

local enemy=nil
local distance=9999999
local targetedEnemy=nil

for i,v in ipairs(ents) do
if v.entity:IsVisible() and not v.components.health:IsDead() then
local vx,vy,vz=v.Transform:GetWorldPosition()
local sq=distsq(x,z,vx,vz)

if
v:HasTag("hostile") and
sq < distance and

(
owner==nil or
owner.components.combat==nil or
owner.components.combat:CanTarget(enemy)
)
then

enemy=v
distance=sq
elseif v.components.combat.target~=nil and v.components.combat.target:HasTag("player") then
targetedEnemy=v
end
end
end

return targetedEnemy or enemy
end

local GuardianOrb=Class(function(self,inst)
self.inst=inst


self.owner=nil

self.angle=0

self.orbs={}

self.timeout=0

self.spawnPrefab=nil

self.projectilePrefab=nil

self.projectileTimeout=0
end)


function GuardianOrb:Start(owner)
self.owner=owner
self.inst:StartUpdatingComponent(self)
end


function GuardianOrb:Stop()
self.inst:StopUpdatingComponent(self)

for i=1,#self.orbs do
local orb=self.orbs[i]
local explode=SpawnPrefab("explode_firecrackers")
local x,y,z=orb.Transform:GetWorldPosition()
explode.Transform:SetPosition(x,y+1,z)
explode.Transform:SetScale(0.3,0.3,0.3)
orb:Remove()
end

self.orbs={}
end


function GuardianOrb:OnUpdate(dt)
local instPos=self.inst:GetPosition()


if self.owner==nil or not self.owner.components.health or self.owner.components.health:IsDead() then
self:Stop()
end


self.timeout=self.timeout+dt
if self.timeout >=INCREASE_TIMEOUT then
self.timeout=math.mod(self.timeout,INCREASE_TIMEOUT)


if #self.orbs < MAX_COUNT then
local orb=SpawnPrefab(self.spawnPrefab)
table.insert(self.orbs,orb)
orb.Transform:SetPosition(instPos.x,instPos.y,instPos.z)
orb.Physics:SetMotorVel(ORB_SPEED,0,0)
orb._master=true


if #self.orbs==1 then
self.projectileTimeout=0
end
end
end


self.projectileTimeout=self.projectileTimeout+dt


self.angle=math.mod((self.angle+dt*ANGLE_SPEED),360)
local dist=999999

local target=nil
local targetPos=nil
if self.projectileTimeout > PROJECTILE_INTERVAL then
target=findNearEnemy(self.inst,self.owner)
if target~=nil then
targetPos=target:GetPosition()
end
end

for i=1,#self.orbs do
local orb=self.orbs[i]
local orbPos=orb:GetPosition()


local sq=distsq(orbPos.x,orbPos.z,instPos.x,instPos.z)
if sq > DISTANCE_FAST*DISTANCE_FAST then

orb:FacePoint(instPos)
orb.Physics:SetMotorVel(ORB_SPEED_FAST,0,0)
else

local targetPoint=getTargetPoint(self.angle,instPos,i-1)
orb:FacePoint(targetPoint)
orb.Physics:SetMotorVel(ORB_SPEED,0,0)
end


if target~=nil then
local targetPos=target:GetPosition()
local sq=distsq(targetPos.x,targetPos.z,orbPos.x,orbPos.z)

if sq < dist then
dist=sq
end

if i==#self.orbs and dist==sq then

local proj=SpawnPrefab(self.projectilePrefab)
local x,y,z=orb.Transform:GetWorldPosition()
proj.Transform:SetPosition(orb.Transform:GetWorldPosition())
proj.components.projectile:SetSpeed(ORB_SPEED_FAST)
proj.components.projectile:Throw(self.inst,target,self.owner)


table.remove(self.orbs,i)
orb:Remove()
self.projectileTimeout=0
end
end
end
end

return GuardianOrb