
local Aura=Class(function(self,inst)
self.inst=inst
self.range=15
self.bufferName=nil
self.bufferDuration=nil
self.bufferFn=nil
self.mustTags=nil
self.noTags=nil
self.showFX=true

self:Start()
end)

local function SearchToAddBuffer(inst,self)
local x,y,z=inst.Transform:GetWorldPosition()
local ents=TheSim:FindEntities(x,y,z,self.range,self.mustTags,self.noTags)

for i,ent in ipairs(ents) do
patchBuffer(ent,self.bufferName,self.bufferDuration,self.bufferFn,self.showFX)
end
end

function Aura:Start()
self:Stop()

self.task=self.inst:DoPeriodicTask(1.5,SearchToAddBuffer,0.1,self)
end

function Aura:Stop()
if self.task~=nil then
self.task:Cancel()
self.task=nil
end
end

return Aura