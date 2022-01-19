
local Float=Class(function(self,inst)
self.inst=inst
self.targetPos=nil
self.speed=6
self.ySpeed=6
end)


function Float:RotateToTarget(dest)
local angle=aipGetAngle(self.inst:GetPosition(),dest)
self.inst.Transform:SetRotation(angle)
self.inst:FacePoint(dest)
end


function Float:GoToPoint(pt)
self.targetPos=pt
self.inst.Physics:Teleport(pt.x,pt.y,pt.z)

self.inst:StartUpdatingComponent(self)
end


function Float:MoveToPoint(pt)
self.targetPos=pt
self.inst:StartUpdatingComponent(self)
end

function Float:OnUpdate(dt)
local pos=self.inst:GetPosition()
if not self.targetPos then
return
end


local dist=aipDist(pos,self.targetPos)
local speed=self.speed
if dist < 0.3 then
speed=0.5
end


self:RotateToTarget(self.targetPos)
self.inst.Physics:SetMotorVel(
speed,
(self.targetPos.y-pos.y)*self.ySpeed,
0
)
end

return Float