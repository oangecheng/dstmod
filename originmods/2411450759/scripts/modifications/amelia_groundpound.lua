local function OnDestroyPoints(inst, self, points, breakobjects, dodamage, pushplatforms)
    self:DestroyPoints(points, breakobjects, dodamage, pushplatforms)
end
local scale = 0.7
local function GroundPound(self,pt)
    pt = pt or self.inst:GetPosition()
    local ring = SpawnPrefab(self.groundpoundringfx)
    ring.Transform:SetPosition(pt:Get())
    ring.Transform:SetScale(scale,scale,scale)
    local points = self:GetPoints(pt)
    local delay = 0
    for i = 1, self.numRings do
        self.inst:DoTaskInTime(delay, OnDestroyPoints, self, points[i], i <= self.destructionRings, i <= self.damageRings, i <= self.platformPushingRings)
        delay = delay + self.ringDelay
    end

    if self.groundpoundFn ~= nil then
        self.groundpoundFn(self.inst)
    end
end
return GroundPound