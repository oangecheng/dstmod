local function onReset(inst)
local asb=inst.components.aipc_score_ball
if asb~=nil then
asb:ResetAll()
end
end


local ScoreBall=Class(function(self,inst)
self.inst=inst


self.y=0

self.speed=0
self.ySpeed=0
self.recordSpeed=0
self.yRecordSpeed=0
self.fullTime=0
self.walkTime=0
self.downTimes=0
self.startTimes=0
self.throwTimes=0
end)

function ScoreBall:ResetMotion()
self.inst.Physics:SetMotorVel(0,0,0)
self.inst.Physics:Stop()
end

function ScoreBall:ResetAll()
self:ResetMotion()
self.startTimes=0
self.downTimes=0
self.throwTimes=0
self.playerThrow=false
self.y=0

self.inst.components.aipc_score_ball_effect:StopPlay()

self.inst:StopUpdatingComponent(self)
end

function ScoreBall:Launch(speed,ySpeed,continueBump)

self.inst.components.aipc_score_ball_effect:StartPlay(continueBump,speed,self.y)


self:ResetMotion()
self.startTimes=self.startTimes+1


self.speed=speed
self.ySpeed=ySpeed
self.recordSpeed=speed
self.yRecordSpeed=ySpeed

self.fullTime=1
self.walkTime=0

self.inst.Physics:SetMotorVel(self.speed,0,0)

self.inst:StartUpdatingComponent(self)

self.inst.components.health:SetInvincible(true)
self.inst.components.inventoryitem.canbepickedup=false

self.inst:ListenForEvent("ondropped",onReset)
self.inst:ListenForEvent("onpickup",onReset)
end

function ScoreBall:ResetThrowCount()
local miniDou=FindEntity(self.inst,15,nil,{ "aip_mini_doujiang" })
if miniDou~=nil and miniDou.aipPlayEnd~=nil and self.throwTimes~=0 then
miniDou.aipPlayEnd(miniDou,self.throwTimes)
end

self.throwTimes=0
end

function ScoreBall:Throw(tgtPos,speed,ySpeed)
self.throwTimes=self.throwTimes+1
self.playerThrow=false
self:InternalThrow(tgtPos,speed,ySpeed)
end

function ScoreBall:InternalThrow(tgtPos,speed,ySpeed)
local srcPos=self.inst:GetPosition()
local angle=aipGetAngle(tgtPos,srcPos)
self.inst.Transform:SetRotation(angle)
self.inst:FacePoint(tgtPos)

self.startTimes=0
self.downTimes=0

self:Launch(speed,ySpeed)
end

function ScoreBall:Kick(attacker,speed,ySpeed)
local srcPos=self.inst:GetPosition()
local angle=aipGetAngle(attacker:GetPosition(),srcPos)
local radius=angle/180*PI
local tgtPos=Vector3(srcPos.x+math.cos(radius),0,srcPos.z+math.sin(radius))

self.playerThrow=true

self:InternalThrow(tgtPos,speed,ySpeed)
end


function ScoreBall:CanFollow()

return self.playerThrow and (
(self.startTimes==1 and (self.downTimes==1 or self.y > 7)) or
(self.startTimes==2)
)
end


function ScoreBall:CanThrow()
return self:CanFollow() and (
(self.downTimes==1 and self.y < 1.5) or
(self.startTimes==2 and self.y < 1)
)
end

function ScoreBall:OnUpdate(dt)
local prevWalkTime=self.walkTime
self.walkTime=self.walkTime+dt

local ySpeed=(self.fullTime-self.walkTime)/self.fullTime*self.ySpeed

self.inst.Physics:SetMotorVel(self.speed,0,0)
self.y=self.y+ySpeed*dt
self.inst.components.aipc_score_ball_effect:SyncY(self.y,ySpeed)

if prevWalkTime <=self.fullTime and self.fullTime < self.walkTime then
self.downTimes=self.downTimes+1


if self.downTimes >=3 then
self:ResetThrowCount()
end
end


local canInteractive=self.y <=2.5
self.inst.components.health:SetInvincible(not canInteractive)
self.inst.components.inventoryitem.canbepickedup=canInteractive


if self.walkTime >=self.fullTime and self.y < 0.05 then

self.recordSpeed=self.recordSpeed/2
self.yRecordSpeed=self.yRecordSpeed/3*2

if self.recordSpeed > .2 and self.yRecordSpeed >=1 then
self:Launch(self.recordSpeed,self.yRecordSpeed,true)
else
self:ResetAll()
self:ResetThrowCount()
end
end
end

return ScoreBall