local windyknifestatus = Class(function(self, inst)
    self.inst = inst
    self.level = 0
end,
nil,
{
})

function windyknifestatus:OnSave()
    local data = {
        level = self.level,
    }
    return data
end

function windyknifestatus:OnLoad(data)
    self.level = data.level or 0
end

function windyknifestatus:DoDeltaLevel(delta)
    self.level = self.level + delta
    self.inst:PushEvent("DoDeltaLevelWindyKnife")
end

return windyknifestatus